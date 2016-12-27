#!/usr/bin/with-contenv bash
cd /tmp

# Define drivers supported by the container
DRIVERS_SUPPORTED=("i915" "nvidia")

# Check which drivers are installed on the host OS
declare -a DRIVERS_DETECTED=(`lshw -c video | awk '/configuration: driver/{print $2}' | cut -d '=' -f 2 | tr '\n' ' ' | xargs`)

# Check user provided driver against supported drivers
FOUND=0
for i in "${DRIVERS_SUPPORTED[@]}"
do
  if [[ "$i" == "$GFX_DRIVER"  ]]; then
    FOUND=1
    break
  fi
done
if [[ "$FOUND" == "0" ]]; then
  echo "ERROR: Driver $GFX_DRIVER is not found in the list of supported drivers ($DRIVERS_SUPPORTED)"
  exit 1
fi

# Check user provided driver against installed drivers on host OS
FOUND=0
for i in "${DRIVERS_DETECTED[@]}"
do
  if [[ "$i" == "$GFX_DRIVER"  ]]; then
    FOUND=1
    break
  fi
done
if [[ "$FOUND" == "0" ]]; then
  echo "ERROR: Driver $GFX_DRIVER is not found in the list of installed drivers ($DRIVERS_DETECTED)"
  exit 1
fi

# Take appropriate action depending on provided driver
case $GFX_DRIVER in
    nvidia )
        echo "NVIDIA Driver detected on host system"
        gfx_version=`cat /proc/driver/nvidia/version | head -n 1 | awk '{ print $8 }'`
        echo "NVIDIA driver version on host system is $gfx_version"
        if [ ! -f "/usr/share/nvidia/nvidia-application-profiles-${gfx_version}-rc" ]; then
                echo "Downloading new NVIDIA driver version ${gfx_version}"
                nvidia_driver_uri=http://us.download.nvidia.com/XFree86/Linux-x86_64/${gfx_version}/NVIDIA-Linux-x86_64-${gfx_version}.run
                curl -o nvidia-driver.run $nvidia_driver_uri
                chmod 755 /tmp/nvidia-driver.run
                echo "Installing driver"
                /tmp/nvidia-driver.run -a -N --ui=none --no-kernel-module --run-nvidia-xconfig --silent
                echo "Driver installed"
        else
                echo "NVIDIA driver ${gfx_version} already installed"
        fi
        ;;
    ati_placeholder )
        ;;
esac
