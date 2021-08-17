extends SplitContainer
class_name MessageCont, "res://icon.png"

var _username := ""
var _text := ""

func set_username(username : String) -> void:
    _username = username
    $NameContainer/MarginContainer/Username.text = _username + ":"

func set_text(text : String) -> void:
    _text = text
    if _text:
        $HSplitContainer/VSplitContainer/MarginContainer/MessageText.text = text

func set_meme(meme_link : String) -> void:
    var encoded = meme_link.get_file()
    var file = File.new()
    var directory_location = "user://meme_cache"
    var directory = Directory.new()
    if not directory.dir_exists(directory_location):
        directory.make_dir(directory_location)

    var file_location = directory_location + "/" + encoded
    if file.file_exists(file_location):
        file.open(file_location, File.READ)
        var image = file.get_buffer(file.get_len())
        $HSplitContainer/VSplitContainer/ImageContainer/ImageRect.texture = array2image(image)
        file.close()
    else:
        var download_task = Firebase.Storage.ref(meme_link).get_data()
        yield(download_task, "task_finished")
        $HSplitContainer/VSplitContainer/ImageContainer/ImageRect.texture = task2image(download_task)
        var result = file.open(file_location, File.WRITE_READ)
        file.store_buffer(download_task.data)
        file.close()

func task2image(task : StorageTask) -> ImageTexture:
    var new_image = array2image(task.data)
    return new_image

func array2image(array) -> ImageTexture:
    var new_image = Image.new()
    match typeof(array):
        TYPE_RAW_ARRAY:
            var data : PoolByteArray = array
            if data.size() > 1:
                match data.subarray(0,1).hex_encode():
                    "ffd8":
                        new_image.load_jpg_from_buffer(data)
                    "8950":
                        new_image.load_png_from_buffer(data)
        TYPE_DICTIONARY:
            print("ERROR %s: could not find dictionary")

    var new_texture := ImageTexture.new()
    new_texture.create_from_image(new_image)
    return new_texture
