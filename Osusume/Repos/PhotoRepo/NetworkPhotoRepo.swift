class NetworkPhotoRepo : PhotoRepo {
    func configureCredentials() {
        let identityPoolId = "ap-northeast-1:f65d8e6f-ac25-46b1-8106-f72026005681"
        let regionType = AWSRegionType.APNortheast1

        // Initialize the Amazon Cognito credentials provider
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: regionType,
            identityPoolId: identityPoolId
        )

        let configuration = AWSServiceConfiguration(
            region: regionType,
            credentialsProvider: credentialsProvider
        )

        AWSServiceManager
            .defaultServiceManager()
            .defaultServiceConfiguration = configuration
    }

    func uploadPhoto(photo: UIImage) -> String {
        let key = "user_id/\(NSUUID().UUIDString)"
        let bucketName = "osusume-tokyo-dev"

        let fileName = key.componentsSeparatedByString("/").last
        let photoTempURL = NSURL(
            fileURLWithPath: NSTemporaryDirectory().stringByAppendingString(fileName!)
        )

        UIImageJPEGRepresentation(photo, 1.0)?.writeToURL(photoTempURL, atomically: true)

        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        let uploadRequest = AWSS3TransferManagerUploadRequest()

        uploadRequest.bucket = bucketName
        uploadRequest.key = key
        uploadRequest.body = photoTempURL
        uploadRequest.ACL = AWSS3ObjectCannedACL.PublicRead

        transferManager.upload(uploadRequest)

        return "https://s3-ap-northeast-1.amazonaws.com/\(bucketName)/\(key)"
    }
}
