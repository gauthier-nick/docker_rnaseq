# Create a Dockerfile to build the image
FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
# Set the geographic area environment variable to a default value
ENV GEOGRAPHIC_AREA=America

# Install necessary packages for the RNA-seq pipeline
RUN apt-get update && apt-get install -y \
    cutadapt \
    fastp \
    minimap2 \
    samtools \
    salmon \
    build-essential \
nano \
less \
porechop \
git \
wget \
curl \
    python3-pip

# Clone the filtlong repository and build it
RUN git clone https://github.com/rrwick/Filtlong.git \
    && cd Filtlong \
    && make -j

# Move filtlong binary to /usr/local/bin
RUN cp Filtlong/bin/filtlong /usr/local/bin
# Install Python packages
RUN pip3 install numpy


# Set the working directory to /pipeline
WORKDIR /pipeline

# Copy the scripts into the container
COPY rna_seq_pipeline.sh /pipeline/rna_seq_pipeline.sh
# Make the scripts executable
RUN chmod +x /pipeline/rna_seq_pipeline.sh
# Define the entry point to the pipeline script
ENTRYPOINT ["./rna_seq_pipeline.sh"]
