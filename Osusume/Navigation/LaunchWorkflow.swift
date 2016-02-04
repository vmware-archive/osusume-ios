class LaunchWorkflow {
    let sessionRepo: SessionRepo

    init (sessionRepo: SessionRepo) {
        self.sessionRepo = sessionRepo
    }

    func startWorkflow(router: Router) {
        configureS3()

        if let _: String = sessionRepo.getToken() {
            router.showRestaurantListScreen()
        } else {
            router.showLoginScreen()
        }
    }

    private func configureS3() {
        // Initialize the Amazon Cognito credentials provider
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .APNortheast1, identityPoolId: "Identity Pool ID")
        let configuration = AWSServiceConfiguration(region:.APNortheast1, credentialsProvider:credentialsProvider)

        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
    }
}