### INSTALL DEPENDENCIES
paru -S rustup
rustup target add x86_64-pc-windows-gnu
paru -S wine meson mingw-w64 glslang python3

### BUILD

# Compiling the core module
git clone https://github.com/ishitatsuyuki/latencyflex2.git -b v2.0.0-alpha.2
cd ./latencyflex2/core
cargo build --release --target x86_64-pc-windows-gnu
# cp ./target/x86_64-pc-windows-gnu/release/latencyflex2_rust.dll /where/to/copy
cd ../..

# Compiling the DXVK fork
git clone --recursive https://github.com/ishitatsuyuki/dxvk.git -b lfx2-v2.0.0-alpha.2
cd dxvk
./package-release.sh master ./target --no-package
# cp ./target/dxvk-master /where/to/copy
cd ..

# Compiling the DXVK-NVAPI fork
git clone --recursive https://github.com/ishitatsuyuki/dxvk-nvapi.git -b lfx2-v2.0.0-alpha.2
cd ./dxvk-nvapi
./package-release.sh master ./target
# cp ./target/dxvk-nvapi-master /where/to/copy
cd ..

# Compiling the VKD3D-Proton fork
git clone --recursive https://github.com/ishitatsuyuki/vkd3d-proton.git -b lfx2-v2.0.0-alpha.2
cd ./vkd3d-proton
./package-release.sh master ./target --no-package
# cp ./target/vkd3d-proton-master /where/to/copy
cd ..

### INSTALL
# For each steam game, install latencyflex into system32
for COMPATDATA in ~/.steam/steam/steamapps/compatdata/* ; do
  cp -r "./latencyflex2/core/target/x86_64-pc-windows-gnu/release/latencyflex2_rust.dll" "$COMPATDATA/pfx/drive_c/windows/system32/"
  echo "Latency flex installed in $COMPATDATA"
done

# For each proton version
for PROTON_PATH in ~/.steam/steam/steamapps/common/"Proton - Experimental" ; do
  # Install the DXVK fork
  chmod 655 "$PROTON_PATH"/files/lib64/wine/dxvk/*
  yes | cp ./dxvk/target/dxvk-master/x64/*.dll "$PROTON_PATH/files/lib64/wine/dxvk/"
  chmod 555 "$PROTON_PATH"/files/lib64/wine/dxvk/*
  echo "DXVK fork installed in $PROTON_PATH"

  # Install dxvk-nvapi fork
  chmod 655 "$PROTON_PATH"/files/lib64/wine/nvapi/*
  yes | cp ./dxvk-nvapi/target/dxvk-nvapi-master/x64/*.dll "$PROTON_PATH/files/lib64/wine/nvapi/"
  chmod 555 "$PROTON_PATH"/files/lib64/wine/nvapi/*
  echo "DXKV-NVAPI installed in $PROTON_PATH"

  # Install vkd3d-proton fork
  chmod 655 "$PROTON_PATH"/files/lib64/wine/vkd3d-proton/*
  yes | cp ./vkd3d-proton/target/vkd3d-proton-master/x64/*.dll "$PROTON_PATH/files/lib64/wine/vkd3d-proton/"
  chmod 555 "$PROTON_PATH"/files/lib64/wine/vkd3d-proton/*
  echo "DXVK-NVAPI installed in $PROTON_PATH"
done

