FROM registry.opensuse.org/opensuse/tumbleweed:latest
LABEL org.opencontainers.image.source="https://github.com/aardsoft/ci-images"

ARG RUNNER_VERSION=2.332.0
ARG TARGETPLATFORM
ARG RUNNER_CONTAINER_HOOKS_VERSION=0.8.1

ENV UID=1000
ENV GID=0
ENV USERNAME="runner"
ENV XDG_RUNTIME_DIR=/run/user/1000

RUN zypper addrepo https://download.opensuse.org/repositories/Virtualization:/containers/openSUSE_Tumbleweed/Virtualization:containers.repo && zypper addrepo https://cli.github.com/packages/rpm/gh-cli.repo && zypper --gpg-auto-import-keys ref -f
RUN zypper -n in xz skopeo obs-service-kiwi_label_helper obs-service-replace_using_package_version obs-service-kiwi_metainfo_helper build skopeo umoci fakechroot fakeroot tar gzip bzip2 unzip sudo git jq gh wget strace podman libxml2-tools jing python3-kiwi libicu libnuma1 liburcu8 liblttng-ust-ctl6 liblttng-ust1 liblttng-ust-python-agent1 pkgconf-pkg-config liburcu-devel lttng-ust-devel

RUN useradd -G 0 $USERNAME && echo "runner   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/runner
ENV HOME=/home/${USERNAME}

RUN mkdir -p /home/runner/.docker \
    && chown -R $USERNAME:$GID /home/runner \
    && mkdir -p /run/user/1000 && chown -R $USERNAME:$GID /run/user/1000
WORKDIR /home/runner

RUN export ARCH=$(echo ${TARGETPLATFORM} | cut -d / -f2) \
    && if [ "$ARCH" = "amd64" ]; then export ARCH=x64 ; fi \
    && curl -L -o runner.tar.gz https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./runner.tar.gz \
    && rm runner.tar.gz

# This fails on newer distributions due to outdated package list in the runner
# scripts. We need to manually ensure we have all dependencies.
#    && ./bin/installdependencies.sh

RUN curl -f -L -o runner-container-hooks.zip https://github.com/actions/runner-container-hooks/releases/download/v${RUNNER_CONTAINER_HOOKS_VERSION}/actions-runner-hooks-k8s-${RUNNER_CONTAINER_HOOKS_VERSION}.zip \
    && unzip ./runner-container-hooks.zip -d ./k8s \
    && rm runner-container-hooks.zip

USER runner