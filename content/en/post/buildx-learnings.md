## doh file

Always patch the kernel with static binaries for qemu

You don't need to re-create the builder for reset

For multi arch we are using docker-container driver

docker-container driver is unable to see `docker images` registry, so a container is needed for a local one

it is easier if local registry runs with network host, or prepare for network overlay shenanigans

magic parameters for builder

--builder-opts network:host
--config=<path>

Config fie must include the following

[registry]
  [registry."jossemargt-xps-8300.lan:5000"]
    http = true

docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --name multiarch --driver docker-container --use --bootstrap --driver-opt network=host --config=$(pwd)/buildkit.toml
