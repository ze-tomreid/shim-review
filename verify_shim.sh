#!/bin/bash
# Run this to build shim, and compare the resultant 
# EFI binaries with those already in the tree.

#TODO: REPLACE db.cert with our real certificate.
# Docker first downloads and checks shim 15.7 sources, and builds shim 
# with the following patches, SBAT, and certificate:
# .
# ├── patches
# │   ├── 0001-Make-sbat_var.S-parse-right-with-buggy-gcc-binutils.patch
# │   └── 0002-Enable-the-NX-compatibility-flag-by-default.patch
# ├── db.crt
# ├── sbat.ziperase.csv
# └── shim-15.7.tar.bz2.sha512


# Next the resultant binaries are compared in a docker container to the
# submitted EFIs in the root of our tree:
# .
# ├── shimia32.efi
# └── shimx64.efi

# The output of the verification can be found inside ./verify-output
# ├── verify-output
# │   ├── build-ia32.log      <--- A log of the 32-bit shim build
# │   ├── build-x64.log       <--- A log of the 64-bit shim build
# │   ├── diff.log            <--- A summary of the differences between submitted EFIs and the verification builds
# │   ├── packages_list.txt   <--- A list of packages installed in the build environment
#     └── sha256sum.log       <--- Checksums for each of the EFIs, both submitted and verification builds

# Logs and package list for the original submitted builds can also be found in the root of the tree:
# .
# ├── build-ia32.log
# ├── build-x64.log
# └── packages_list.txt

#TODO: REPLACE db.cert with our real certificate.
docker buildx build --progress=plain --no-cache \
      --secret id=cert,src="db.crt" \
      --target verify_shim \
      -o ./verify-output .