import BSImagePicker
import Photos

@testable import Osusume

class FakeImagePicker: ImagePicker {
    private(set) var bs_presentImagePickerController_wasCalled = false
    func bs_presentImagePickerController(
        imagePicker: BSImagePickerViewController,
        animated: Bool,
        select: ((asset: PHAsset) -> Void)?,
        deselect: ((asset: PHAsset) -> Void)?,
        cancel: (([PHAsset]) -> Void)?,
        finish: (([PHAsset]) -> Void)?,
        completion: (() -> Void)?)
    {
        bs_presentImagePickerController_wasCalled = true
    }
}

