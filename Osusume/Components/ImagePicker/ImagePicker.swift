import BSImagePicker
import Photos

protocol ImagePicker {
    func bs_presentImagePickerController(
        imagePicker: BSImagePicker.BSImagePickerViewController,
        animated: Bool,
        select: ((asset: PHAsset) -> Void)?,
        deselect: ((asset: PHAsset) -> Void)?,
        cancel: (([PHAsset]) -> Void)?,
        finish: (([PHAsset]) -> Void)?,
        completion: (() -> Void)?
    )
}
