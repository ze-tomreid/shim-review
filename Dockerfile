FROM debian:bullseye as build_env
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y --no-install-recommends --allow-unauthenticated build-essential \
        # for `hexdump`
        bsdmainutils \
        # for `git clone`
        ca-certificates git \
        # for `make` with `sbat.ecos.csv`
        dos2unix \
        # for download and extraction of the shim release
        wget tar \
        # reduce image size by cleaning up apt list cache
        && rm -rf /var/lib/apt/lists/*
# Log installed packages in the build environment.
RUN apt list --installed > /packages_list.txt
# For verifying shim sources are downloaded as expected.
ADD shim-15.7.tar.bz2.sha512 shim-15.7.tar.bz2.sha512
# Download, verify and extract Shim sources.
RUN wget https://github.com/rhboot/shim/releases/download/15.7/shim-15.7.tar.bz2 && \
        sha512sum -c shim-15.7.tar.bz2.sha512 && \
        tar xvf shim-15.7.tar.bz2 && \
        mv /shim-15.7 /shim
# All work will happen inside the shim source directory.
WORKDIR /shim
# Add and apply any patches.
ADD patches patches
RUN for patchfile in patches/*.patch; do \
        if [ -f $patchfile ]; then \
        patch -p1 -i $patchfile; \
        fi; \
        done
# Add SBAT for version control/revocation.
ADD sbat.ziperase.csv ./data/
# ADD Certificate to embed into shims / with which to verify.
# TODO: Replace this with real CA cert when we have one.
ADD db.crt /shim/db.crt

# Build the binaries with local certificate embedded
FROM build_env as build_stage
# TODO: Replace this with real CA cert when we have one.
ENV VENDOR_CERT_FILE=/shim/db.crt
# Building and output directories
RUN mkdir build-ia32 build-x64 inst
WORKDIR /shim/build-ia32
# Build the 32 bit binaries into /shim/inst
RUN setarch linux32 make TOPDIR=.. ARCH=ia32 -j -f ../Makefile | tee ../build-ia32.log
WORKDIR /shim/build-x64
# Build the 64 bit binaries into /shim/inst
RUN make TOPDIR=.. -j -f ../Makefile | tee ../build-x64.log
WORKDIR /shim/install

FROM build_stage as verify_shim_build
ADD shimx64.efi /shim-review/shimx64.efi
ADD shimia32.efi /shim-review/shimia32.efi
WORKDIR /
# Dump contents of verification build into a file
RUN hexdump -Cv /shim/build-x64/shimx64.efi > build
RUN hexdump -Cv /shim/build-ia32/shimia32.efi >> build
# Dump contents of our latest committed build into a file 
RUN hexdump -Cv /shim-review/shimx64.efi > orig
RUN hexdump -Cv /shim-review/shimia32.efi >> orig
# Compare the file - an empty file means they are the same
RUN diff -u orig build | tee /diff.log
# Collect sha256sums for all files in comparison
RUN sha256sum /shim/build-x64/shimx64.efi /shim-review/shimx64.efi /shim/build-ia32/shimia32.efi /shim-review/shimia32.efi | tee /sha256sum.log

# TARGET THIS TO VERIFY AN EXISTING BUILD
FROM scratch as verify_shim
# Output of verification
COPY --from=build_env /packages_list.txt /
COPY --from=verify_shim_build /diff.log /
COPY --from=build_stage /shim/build-x64.log /
COPY --from=build_stage /shim/build-ia32.log /
COPY --from=verify_shim_build /sha256sum.log /
