class LaunchWorkflow {
    let sessionRepo: SessionRepo
    let photoRepo: PhotoRepo

    init (sessionRepo: SessionRepo, photoRepo: PhotoRepo) {
        self.sessionRepo = sessionRepo
        self.photoRepo = photoRepo
    }

    func startWorkflow(router: Router) {
        photoRepo.configureCredentials()

        if let _ = sessionRepo.getToken() {
            router.showRestaurantListScreen()
        } else {
            router.showLoginScreen()
        }
    }
}
