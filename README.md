# Git LFS Workflow with Okteto

This repository demonstrates how to effectively use Git LFS (Large File Storage) with Okteto for cloud-native development. It showcases a workflow that allows developers to work with repositories containing large files without requiring local Git LFS installation or downloading large files to their local machines.


# Workflow Benefits

This approach provides several advantages:

1. **No Local LFS Requirements**: Developers don't need Git LFS installed locally
2. **Reduced Local Storage**: Large files remain in LFS storage and aren't downloaded to local machines
3. **Remote-First Development**: LFS files are only retrieved in the remote Okteto environment where they're needed
4. **Seamless Integration**: Works with existing Docker Compose deployments
5. **Flexible Image Strategy**: Supports both custom-built and pre-existing LFS-enabled images


# Key Components

### Custom LFS Docker Image (`custom-lfs/Dockerfile`)

The `custom-lfs/Dockerfile` represents a custom image that includes the Git LFS tooling necessary for remote environments during Okteto deployments (via Okteto CLI or UI). This lightweight Debian-based image:

- Installs `git-lfs` package
- Configures the Git LFS extension with `git lfs install`

Alternatively, if you already have a preferred image with Git LFS support, you can:
1. Remove the `build` section from the Okteto manifest
2. Directly reference your image using the `deploy.image` key in the Okteto manifest

### Okteto Ignore Configuration (`.oktetoignore`)

The `.oktetoignore` file excludes the `.git/lfs` directory from synchronization because:
- Okteto handles LFS file retrieval through the `git lfs pull` command in the deploy process as seen under `deploy.commands` in the Okteto Manifest, `okteto.yaml`.
- This approach allows developers to work with LFS repositories without downloading large files locally
- Developers don't need to have Git LFS configured on their local machines

### Okteto Manifest (`okteto.yaml`)

The Okteto manifest orchestrates the entire workflow:

**Build Section**:
- Builds the custom LFS image through the `build` section
- Creates an image with Git LFS tooling available

**Deploy Section**:
- Uses the custom LFS image (`${OKTETO_BUILD_LFS_IMAGE}`)
- Executes a sequence of commands:
  1. `ls -al` - Verifies that LFS files are not present initially (optional, for demonstration)
  2. `git lfs pull` - Downloads the actual LFS files to the remote environment
  3. `ls -al` - Confirms LFS files are now available (optional, for demonstration)
  4. `okteto deploy -f docker-compose.yaml` - Deploys the application with access to the LFS files

NOTE: The `ls` commands are included for verification purposes but are not required.


# Getting Started

1. Ensure your large files are tracked with Git LFS (see `.gitattributes`)
2. Deploy to Okteto using `okteto deploy`, `okteto pipeline deploy`, or through the UI
3. The workflow will automatically handle LFS file retrieval and application deployment

This setup enables efficient cloud-native development with Git LFS while maintaining a smooth developer experience.
