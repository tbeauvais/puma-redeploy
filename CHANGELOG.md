# Changelog

## v0.4.1

**Fixes:**

- Fix issue when watch file is initially missing

## v0.4.0

**Fixes and enhancements:**

- Fix the order when running commands to run after unzip archive. Also bump to 0.4.0


## v0.3.4

**Features:**

- Add support to run commands prior to redeploy using a yaml watch file. This is useful for running a migration or bundle gems.

## v0.3.3

**Fixes and enhancements:**

- don't require specific version of aws s3 gem

## v0.3.2

**Fixes and enhancements:**

- Improve s3 error handling

## v0.3.1

**Fixes and enhancements:**

- Allow watch file to not exist


## v0.3.0

**Breaking Changes:**
- Rename load_archive to archive-loader
- Add options flags to archive-loader

**Fixes and enhancements:**

## v0.2.1

**Features:**

- Add support for S3 handler

**Fixes and enhancements:**

- Refactor file handler to use new base handler class

## v0.1.1

**Fixes and enhancements:**

- Initial File based handler support
