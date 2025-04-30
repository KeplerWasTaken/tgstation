/datum/map_template/dungeons
    var/customPath

/datum/map_template/dungeons/New(path = customPath, rename = null, cache = FALSE)
    ..(customPath,rename,cache)
