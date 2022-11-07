FROM registry.gitlab.inria.fr/andromak/killerdroid_packer/kdp_standalone:latest as kdp

FROM jupyter/base-notebook

COPY --from=kdp /app/build/libs/killerdroidpacker-v3.1.3-36-gb65ae20.dirty.jar /app/killerdroidpacker.jar
COPY examples /app/examples

USER root
RUN apt update && apt install -y openjdk-17-jre git wget gcc

WORKDIR /tmp

# use a read-only project token
RUN git clone https://plop:glpat-6oXeG_GcqN4Ftc72GNB_@gitlab.inria.fr/andromak/python-andromak /app/python-andromak

WORKDIR /app/python-andromak

RUN mamba env update --file environment.yml
RUN mamba install ipython ipython ipykernel
# FIXME (a too old version of EnOSlib in the deps -- only useful when deploying on g5k)
RUN source "${CONDA_DIR}/etc/profile.d/conda.sh" && conda activate andromak && pip install -U -e . && pip install -U enoslib
RUN mamba clean --all -f -y

RUN "${CONDA_DIR}/envs/andromak/bin/python" -m ipykernel install --user --name=andromak && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

WORKDIR "/home/${NB_USER}"
# FIXME: hardcoding the path here might not be a good idea
ENV PATH="${CONDA_DIR}/bin:${PATH}:${CONDA_DIR}/envs/andromak/bin" \
