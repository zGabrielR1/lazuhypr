#!/usr/bin/env bash

#// set variables
export thmbDir="$HOME/.cache/hyde/thumbs"
export dcolDir="$HOME/.cache/hyde/dcols"
export cacheDir="$HOME/.cache/hyde"
mkdir -p "${thmbDir}" "${dcolDir}" "${cacheDir}/wallpapers"

#// define functions

fn_wallcache() {
    local x_hash="${1}"
    local x_wall="${2}"
    local is_video
    is_video=$(file --mime-type -b "${x_wall}" | grep -c '^video/')

    if [ "${is_video}" -eq 1 ]; then
        if
            [ ! -e "${thmbDir}/${x_hash}.thmb" ] ||
                [ ! -e "${thmbDir}/${x_hash}.sqre" ] ||
                [ ! -e "${thmbDir}/${x_hash}.blur" ] ||
                [ ! -e "${thmbDir}/${x_hash}.quad" ]
        then
            local temp_image="/tmp/${x_hash}.png"
            echo "Extracting thumbnail from video wallpaper..."
            ffmpeg -y -i "${x_wall}" -vf "thumbnail,scale=1000:-1" -frames:v 1 -update 1 "${temp_image}" &>/dev/null
            x_wall="${temp_image}"
        fi
    fi

    [ ! -e "${thmbDir}/${x_hash}.thmb" ] && magick "${x_wall}"[0] -strip -resize 1000 -gravity center -extent 1000 -quality 90 "${thmbDir}/${x_hash}.thmb"
    [ ! -e "${thmbDir}/${x_hash}.sqre" ] && magick "${x_wall}"[0] -strip -thumbnail 500x500^ -gravity center -extent 500x500 "${thmbDir}/${x_hash}.sqre.png" && mv "${thmbDir}/${x_hash}.sqre.png" "${thmbDir}/${x_hash}.sqre"
    [ ! -e "${thmbDir}/${x_hash}.blur" ] && magick "${x_wall}"[0] -strip -scale 10% -blur 0x3 -resize 100% "${thmbDir}/${x_hash}.blur"
    [ ! -e "${thmbDir}/${x_hash}.quad" ] && magick "${thmbDir}/${x_hash}.sqre" \( -size 500x500 xc:white -fill "rgba(0,0,0,0.7)" -draw "polygon 400,500 500,500 500,0 450,0" -fill black -draw "polygon 500,500 500,0 450,500" \) -alpha Off -compose CopyOpacity -composite "${thmbDir}/${x_hash}.quad.png" && mv "${thmbDir}/${x_hash}.quad.png" "${thmbDir}/${x_hash}.quad"

    if [ "${is_video}" -eq 1 ]; then
        rm -f "${temp_image}"
    fi
}

fn_wallcache_force() {
    local x_hash="${1}"
    local x_wall="${2}"

    is_video=$(file --mime-type -b "${x_wall}" | grep -c '^video/')

    if [ "${is_video}" -eq 1 ]; then
        local temp_image="/tmp/${x_hash}.png"
        ffmpeg -y -i "${x_wall}" -vf "thumbnail,scale=1000:-1" -frames:v 1 -update 1 "${temp_image}" &>/dev/null
        x_wall="${temp_image}"
    fi

    magick "${x_wall}"[0] -strip -resize 1000 -gravity center -extent 1000 -quality 90 "${thmbDir}/${x_hash}.thmb"
    magick "${x_wall}"[0] -strip -thumbnail 500x500^ -gravity center -extent 500x500 "${thmbDir}/${x_hash}.sqre.png" && mv "${thmbDir}/${x_hash}.sqre.png" "${thmbDir}/${x_hash}.sqre"
    magick "${x_wall}"[0] -strip -scale 10% -blur 0x3 -resize 100% "${thmbDir}/${x_hash}.blur"
    magick "${thmbDir}/${x_hash}.sqre" \( -size 500x500 xc:white -fill "rgba(0,0,0,0.7)" -draw "polygon 400,500 500,500 500,0 450,0" -fill black -draw "polygon 500,500 500,0 450,500" \) -alpha Off -compose CopyOpacity -composite "${thmbDir}/${x_hash}.quad.png" && mv "${thmbDir}/${x_hash}.quad.png" "${thmbDir}/${x_hash}.quad"

    if [ "${is_video}" -eq 1 ]; then
        rm -f "${temp_image}"
    fi
}

#// evaluate options

while getopts "w:t:f" option; do
    case $option in
    w) # generate cache for input wallpaper
        if [ -z "${OPTARG}" ] || [ ! -f "${OPTARG}" ]; then
            echo "Error: Input wallpaper \"${OPTARG}\" not found!"
            exit 1
        fi
        cacheIn="${OPTARG}"
        ;;
    t) # generate cache for input theme
        cacheIn="$(dirname "$HOME/.config/hypr")/${OPTARG}"
        if [ ! -d "${cacheIn}" ]; then
            echo "Error: Input theme \"${OPTARG}\" not found!"
            exit 1
        fi
        ;;
    f) # full cache rebuild
        cacheIn="$HOME/Pictures"
        mode="_force"
        ;;
    *) # invalid option
        echo "... invalid option ..."
        echo "$(basename "${0}") -[option]"
        echo "w : generate cache for input wallpaper"
        echo "t : generate cache for input theme"
        echo "f : full cache rebuild"
        exit 1
        ;;
    esac
done

#// generate cache

# If no option provided, cache all wallpapers
if [ -z "${cacheIn}" ]; then
    cacheIn="$HOME/Pictures/wallpapers"
fi

# Find all image files
find "${cacheIn}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) 2>/dev/null | while read -r wallpaper; do
    hash=$(sha1sum "${wallpaper}" | awk '{print $1}')
    echo "Caching: ${wallpaper}"
    "fn_wallcache${mode}" "${hash}" "${wallpaper}"
done

exit 0