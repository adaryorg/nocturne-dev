if [ ! -f /etc/os-release ]; then
    echo "Might be Mac"
else
    . /etc/os-release
    case $ID in
    "ubuntu")
        echo "Ubuntu detected"
        if [ $(echo "$VERSION_ID >= 24.04" | bc) != 1 ]; then
            echo "Ubuntu versions older than 24.04 are not supported!"
            exit 1
        fi
        source ~/.nocturne/bootstrap/bootstrap-ubuntu.sh
        ;;
    "arch")
        echo "Arch detected"
        source ~/.nocturne/bootstrap/bootstrap-arch.sh
        ;;
    "fedora")
        echo "Fedora detected"
        if [ $(echo "$VERSION_ID >= 41" | bc) != 1 ]; then
            echo "Fedora versions older than 41 are not supported!"
            exit 1
        fi
        source ~/.nocturne/bootstrap/bootstrap-fedora.sh
        ;;
    *)
        echo "Unknown linux distribution detected ($ID). Support might be added in the future."
        exit 1
        ;;
    esac
fi
