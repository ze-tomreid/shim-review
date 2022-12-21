This repo is for review of requests for signing shim.  To create a request for review:

- clone this repo
- edit the template below
- add the shim.efi to be signed
- add build logs
- add any additional binaries/certificates/SHA256 hashes that may be needed
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push that to github
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your tag
- approval is ready when the "accepted" label is added to your issue

Note that we really only have experience with using GRUB2 on Linux, so asking
us to endorse anything else for signing is going to require some convincing on
your part.

Here's the template:

*******************************************************************************
### What organization or people are asking to have this signed?
*******************************************************************************
Ziperase LLC 

*******************************************************************************
### What product or service is this for?
*******************************************************************************
Ziperase provide bootable software products to erase storage media that are used in enterprise and recycling settings.

*******************************************************************************
### What's the justification that this really does need to be signed for the whole world to be able to boot it?
*******************************************************************************
A core principle of full disk erasure is to provide a trusted certificate of completion for compliance with various global standards. Secure boot support ensures that nobody can modify our boot chain, and break that trust.
Most of our users do not have the ability to disable secure boot on all of the machines they are looking to erase.

*******************************************************************************
### Why are you unable to reuse shim from another distro that is already signed?
*******************************************************************************
We wish to retain the ability to apply patches to kernel drivers. 
Our upstream distro does not have secure boot support.

*******************************************************************************
### Who is the primary contact for security updates, etc.?
The security contacts need to be verified before the shim can be accepted. For subsequent requests, contact verification is only necessary if the security contacts or their PGP keys have changed since the last successful verification.

An authorized reviewer will initiate contact verification by sending each security contact a PGP-encrypted email containing random words.
You will be asked to post the contents of these mails in your `shim-review` issue to prove ownership of the email addresses and PGP keys.
*******************************************************************************
- Name: Thomas Reid
- Position: Engineer
- Email address: tom.reid@ziperase.com
- PGP key fingerprint: `A1AC 6F9B B20A 530E 9D09  BDDC 50D1 7BD8 35FD 4073`

Signed by Colin Myers (below) and pushed to [the openpgp keyserver](keys.openpgp.org)

*******************************************************************************
### Who is the secondary contact for security updates, etc.?
*******************************************************************************
- Name: Colin Myers
- Position: Senior Engineer
- Email address: colin.myers@ziperase.com
- PGP key fingerprint: `34C4 A14D D147 2176 B55F  EA52 BF9B 0C7C 8D2E 9BF8`

Signed by Thomas Reid (above) and pushed to [the openpgp keyserver](keys.openpgp.org)

*******************************************************************************
### Were these binaries created from the 15.7 shim release tar?
Please create your shim binaries starting with the 15.7 shim release tar file: https://github.com/rhboot/shim/releases/download/15.7/shim-15.7.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/15.7 and contains the appropriate gnu-efi source.

*******************************************************************************
Yes.

*******************************************************************************
### URL for a repo that contains the exact code which was built to get this binary:
*******************************************************************************
https://github.com/ze-tomreid/shim-review

*******************************************************************************
### What patches are being applied and why:
*******************************************************************************
Patches can be found in `./patches`.

```
.
├── 0001-Make-sbat_var.S-parse-right-with-buggy-gcc-binutils.patch
└── 0002-Enable-the-NX-compatibility-flag-by-default.patch
```

`0001-`... Addresses https://github.com/rhboot/shim/issues/533
`0002-`... So that we build with support for NX as per https://github.com/rhboot/shim-review/issues/307

*******************************************************************************
### If shim is loading GRUB2 bootloader what exact implementation of Secureboot in GRUB2 do you have? (Either Upstream GRUB2 shim_lock verifier or Downstream RHEL/Fedora/Debian/Canonical-like implementation)
*******************************************************************************
Upstream GRUB2 shim_lock verifier.

*******************************************************************************
### If shim is loading GRUB2 bootloader and your previously released shim booted a version of grub affected by any of the CVEs in the July 2020 grub2 CVE list, the March 2021 grub2 CVE list, the June 7th 2022 grub2 CVE list, or the November 15th 2022 list, have fixes for all these CVEs been applied?

* CVE-2020-14372
* CVE-2020-25632
* CVE-2020-25647
* CVE-2020-27749
* CVE-2020-27779
* CVE-2021-20225
* CVE-2021-20233
* CVE-2020-10713
* CVE-2020-14308
* CVE-2020-14309
* CVE-2020-14310
* CVE-2020-14311
* CVE-2020-15705
* CVE-2021-3418 (if you are shipping the shim_lock module)

* CVE-2021-3695
* CVE-2021-3696
* CVE-2021-3697
* CVE-2022-28733
* CVE-2022-28734
* CVE-2022-28735
* CVE-2022-28736
* CVE-2022-28737

* CVE-2022-2601
* CVE-2022-3775
*******************************************************************************
We have never previously had a shim.
We have applied these patches to the GRUB we intend to ship with this shim.

*******************************************************************************
### If these fixes have been applied, have you set the global SBAT generation on your GRUB binary to 3?
*******************************************************************************
N/A - We have never previously had a shim.

*******************************************************************************
### Were old shims hashes provided to Microsoft for verification and to be added to future DBX updates?
### Does your new chain of trust disallow booting old GRUB2 builds affected by the CVEs?
*******************************************************************************
N/A - We have never previously had a shim.

*******************************************************************************
### If your boot chain of trust includes a Linux kernel:
### Is upstream commit [1957a85b0032a81e6482ca4aab883643b8dae06e "efi: Restrict efivar_ssdt_load when the kernel is locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1957a85b0032a81e6482ca4aab883643b8dae06e) applied?
### Is upstream commit [75b0cea7bf307f362057cc778efe89af4c615354 "ACPI: configfs: Disallow loading ACPI tables when locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=75b0cea7bf307f362057cc778efe89af4c615354) applied?
### Is upstream commit [eadb2f47a3ced5c64b23b90fd2a3463f63726066 "lockdown: also lock down previous kgdb use"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eadb2f47a3ced5c64b23b90fd2a3463f63726066) applied?
*******************************************************************************
```
$ git describe --contains 1957a85b0032a81e6482ca4aab883643b8dae06e
v5.4-rc1~19^2~3
$ git describe --contains 75b0cea7bf307f362057cc778efe89af4c615354
v5.8-rc3~29^2~1
$ git describe --contains eadb2f47a3ced5c64b23b90fd2a3463f63726066
v5.19-rc1~203
```

Our kernel version is currently 5.15.59, so we have the first 2 patches.

The third isn't included in our kernel version but CONFIG_DEBUG_KERNEL is not set in the config.

*******************************************************************************
### Do you build your signed kernel with additional local patches? What do they do?
*******************************************************************************
No.

*******************************************************************************
### If you use vendor_db functionality of providing multiple certificates and/or hashes please briefly describe your certificate setup.
### If there are allow-listed hashes please provide exact binaries for which hashes are created via file sharing service, available in public with anonymous access for verification.
*******************************************************************************
N/A

*******************************************************************************
### If you are re-using a previously used (CA) certificate, you will need to add the hashes of the previous GRUB2 binaries exposed to the CVEs to vendor_dbx in shim in order to prevent GRUB2 from being able to chainload those older GRUB2 binaries. If you are changing to a new (CA) certificate, this does not apply.
### Please describe your strategy.
*******************************************************************************
N/A

*******************************************************************************
### What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as closely as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
### If the shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case and what the differences would be.
*******************************************************************************
See `./verify_shim.sh` a Bash script that launches a docker build. A system with bash and a version of docker with buildx.

*******************************************************************************
### Which files in this repo are the logs for your build?
This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
*******************************************************************************
[your text here]

*******************************************************************************
### What changes were made since your SHIM was last signed?
*******************************************************************************
N/A - We have never previously had a shim.

*******************************************************************************
### What is the SHA256 hash of your final SHIM binary?
*******************************************************************************
[your text here]

*******************************************************************************
### How do you manage and protect the keys used in your SHIM?
*******************************************************************************
Keys are on a FIPS 140-2 security key USB token stored in a physically secured location.

*******************************************************************************
### Do you use EV certificates as embedded certificates in the SHIM?
*******************************************************************************
No.

*******************************************************************************
### Do you add a vendor-specific SBAT entry to the SBAT section in each binary that supports SBAT metadata ( grub2, fwupd, fwupdate, shim + all child shim binaries )?
### Please provide exact SBAT entries for all SBAT binaries you are booting or planning to boot directly through shim.
### Where your code is only slightly modified from an upstream vendor's, please also preserve their SBAT entries to simplify revocation.
*******************************************************************************
Yes.

Shim:
```csv
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
shim,2,UEFI shim,shim,1,https://github.com/rhboot/shim
shim.ziperase,1,Ziperase LLC,shim,15.7,mail:engineering@ziperase.com
```

GRUB:
```csv
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
grub,2,Free Software Foundation,grub,2.06,https://www.gnu.org/software/grub/
grub.ziperase,1,Ziperase LLC,grub2,2.06,https://ziperase.com/
```
*******************************************************************************
### Which modules are built into your signed grub image?
*******************************************************************************
[your text here]

*******************************************************************************
### What is the origin and full version number of your bootloader (GRUB or other)?
*******************************************************************************
2.06 - Patched locally.

Initial source - https://ftp.gnu.org/gnu/grub/grub-2.06.tar.xz 

Patches are all generated from https://git.savannah.gnu.org/git/grub.git.

Cosmetic patches so that the security patches below apply without conflicts:
```
`git format-patch -1 --start-number=1 e453a4a64`
`git format-patch -1 --start-number=2 1f48917d`
```
Yields:
```
0001-net-Remove-trailing-whitespaces.patch
0002-video-Remove-trailing-whitespaces.patch
```

Security patches for the 2022/06/07 vulnerabilities: https://lists.gnu.org/archive/html/grub-devel/2022-06/msg00035.html
```
git format-patch --start-number=3 1469983eb~..2f4430cc0
```
Yields:
```
0003-loader-efi-chainloader-Simplify-the-loader-state.patch
0004-commands-boot-Add-API-to-pass-context-to-loader.patch
0005-loader-efi-chainloader-Use-grub_loader_set_ex.patch
0006-kern-efi-sb-Reject-non-kernel-files-in-the-shim_lock.patch
0007-kern-file-Do-not-leak-device_name-on-error-in-grub_f.patch
0008-video-readers-png-Abort-sooner-if-a-read-operation-f.patch
0009-video-readers-png-Refuse-to-handle-multiple-image-he.patch
0010-video-readers-png-Drop-greyscale-support-to-fix-heap.patch
0011-video-readers-png-Avoid-heap-OOB-R-W-inserting-huff-.patch
0012-video-readers-png-Sanity-check-some-huffman-codes.patch
0013-video-readers-jpeg-Abort-sooner-if-a-read-operation-.patch
0014-video-readers-jpeg-Do-not-reallocate-a-given-huff-ta.patch
0015-video-readers-jpeg-Refuse-to-handle-multiple-start-o.patch
0016-video-readers-jpeg-Block-int-underflow-wild-pointer-.patch
0017-normal-charset-Fix-array-out-of-bounds-formatting-un.patch
0018-net-ip-Do-IP-fragment-maths-safely.patch
0019-net-netbuff-Block-overly-large-netbuff-allocs.patch
0020-net-dns-Fix-double-free-addresses-on-corrupt-DNS-res.patch
0021-net-dns-Don-t-read-past-the-end-of-the-string-we-re-.patch
0022-net-tftp-Prevent-a-UAF-and-double-free-from-a-failed.patch
0023-net-tftp-Avoid-a-trivial-UAF.patch
0024-net-http-Do-not-tear-down-socket-if-it-s-already-bee.patch
0025-net-http-Fix-OOB-write-for-split-http-headers.patch
0026-net-http-Error-out-on-headers-with-LF-without-CR.patch
0027-fs-f2fs-Do-not-read-past-the-end-of-nat-journal-entr.patch
0028-fs-f2fs-Do-not-read-past-the-end-of-nat-bitmap.patch
0029-fs-f2fs-Do-not-copy-file-names-that-are-too-long.patch
0030-fs-btrfs-Fix-several-fuzz-issues-with-invalid-dir-it.patch
0031-fs-btrfs-Fix-more-ASAN-and-SEGV-issues-found-with-fu.patch
0032-fs-btrfs-Fix-more-fuzz-issues-related-to-chunks.patch
```


Security patches for the 2022/11/15 vulnerabilities: https://lists.gnu.org/archive/html/grub-devel/2022-11/msg00059.html
```
git format-patch --start-number=33 f6b623607~..151467888
```
Yields:
```
0033-font-Reject-glyphs-exceeds-font-max_glyph_width-or-f.patch
0034-font-Fix-size-overflow-in-grub_font_get_glyph_intern.patch
0035-font-Fix-several-integer-overflows-in-grub_font_cons.patch
0036-font-Remove-grub_font_dup_glyph.patch
0037-font-Fix-integer-overflow-in-ensure_comb_space.patch
0038-font-Fix-integer-overflow-in-BMP-index.patch
0039-font-Fix-integer-underflow-in-binary-search-of-char-.patch
0040-kern-efi-sb-Enforce-verification-of-font-files.patch
0041-fbutil-Fix-integer-overflow.patch
0042-font-Fix-an-integer-underflow-in-blit_comb.patch
0043-font-Harden-grub_font_blit_glyph-and-grub_font_blit_.patch
0044-font-Assign-null_font-to-glyphs-in-ascii_font_glyph.patch
0045-normal-charset-Fix-an-integer-overflow-in-grub_unico.patch
```

Finally, from https://salsa.debian.org/grub-team/grub/-/blob/master/debian/patches/cve_2022_2601/0001-video-readers-Add-artificial-limit-to-image-dimensio.patch as recommended during another shim review.
```
0046-video-readers-Add-artificial-limit-to-image-dimensio.patch
```
*******************************************************************************
### If your SHIM launches any other components, please provide further details on what is launched.
*******************************************************************************
N/A - it doesn't.

*******************************************************************************
### If your GRUB2 launches any other binaries that are not the Linux kernel in SecureBoot mode, please provide further details on what is launched and how it enforces Secureboot lockdown.
*******************************************************************************
N/A - it doesn't.

*******************************************************************************
### How do the launched components prevent execution of unauthenticated code?
*******************************************************************************
N/A - no other components.

*******************************************************************************
### Does your SHIM load any loaders that support loading unsigned kernels (e.g. GRUB)?
*******************************************************************************
No, grub is locked down with shim_lock.

*******************************************************************************
### What kernel are you using? Which patches does it includes to enforce Secure Boot?
*******************************************************************************
Upstream 5.15.59

*******************************************************************************
### Add any additional information you think we may need to validate this shim.
*******************************************************************************
No.
