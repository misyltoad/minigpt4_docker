FROM archlinux:base-devel

LABEL maintainer="joshua@froggi.es"

RUN mkdir -p /minigpt
WORKDIR /minigpt

RUN pacman-key --init
RUN pacman -Sy --needed --noconfirm archlinux-keyring
RUN pacman -Syu --needed --noconfirm python git cmake wget opencv

RUN wget https://huggingface.co/datasets/maknee/minigpt4-13b-ggml/resolve/main/minigpt4-13B-f16.bin
RUN wget https://huggingface.co/datasets/maknee/ggml-vicuna-v0-quantized/resolve/main/ggml-vicuna-13B-v0-q5_k.bin

RUN pacman -Syu --needed --noconfirm qt6 vtk hdf5 glew fmt python-pip

RUN echo ver1
RUN git clone https://github.com/Joshua-Ashton/minigpt4.cpp
WORKDIR /minigpt/minigpt4.cpp

RUN cmake -DMINIGPT4_BUILD_WITH_OPENCV=ON .
RUN cmake --build . --config Release

WORKDIR /minigpt/minigpt4.cpp/minigpt4
RUN pip install --break-system-packages -r requirements.txt

CMD ["python", "webui.py", "/minigpt/minigpt4-13B-f16.bin", "/minigpt/ggml-vicuna-13B-v0-q5_k.bin"]
