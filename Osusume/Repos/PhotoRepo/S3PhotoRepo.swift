class S3PhotoRepo : PhotoRepo {
    static let regionType = AWSRegionType.APNortheast1
    static let identityPoolId = "ap-northeast-1:f65d8e6f-ac25-46b1-8106-f72026005681"
    static let bucketName = "osusume-tokyo-dev"

    func configureCredentials() {
        // Initialize the Amazon Cognito credentials provider
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: S3PhotoRepo.regionType,
            identityPoolId: S3PhotoRepo.identityPoolId
        )

        let configuration = AWSServiceConfiguration(
            region: S3PhotoRepo.regionType,
            credentialsProvider: credentialsProvider
        )

        AWSServiceManager
            .defaultServiceManager()
            .defaultServiceConfiguration = configuration
    }

    func uploadPhoto(photo: UIImage) -> String {
        let key = "user_id/\(NSUUID().UUIDString)"

        let fileName = key.componentsSeparatedByString("/").last
        let photoTempURL = NSURL(
            fileURLWithPath: NSTemporaryDirectory().stringByAppendingString(fileName!)
        )

        UIImageJPEGRepresentation(photo, 1.0)?.writeToURL(photoTempURL, atomically: true)

        let transferManager: AWSS3TransferManager = AWSS3TransferManager.defaultS3TransferManager()
        let uploadRequest: AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()

        uploadRequest.bucket = S3PhotoRepo.bucketName
        uploadRequest.key = key
        uploadRequest.body = photoTempURL
        uploadRequest.ACL = AWSS3ObjectCannedACL.PublicRead

        transferManager.upload(uploadRequest).continueWithBlock { (AWSTask task) -> AnyObject! in
            if task.error != nil {
                print("Error: \(task.error)")
            } else {
                print("Upload successful")
            }

            return nil
        }

        return "https://s3-ap-northeast-1.amazonaws.com/\(S3PhotoRepo.bucketName)/\(key)"
    }
}
