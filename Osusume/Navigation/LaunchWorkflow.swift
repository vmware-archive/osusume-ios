class LaunchWorkflow {
    let sessionRepo: SessionRepo

    init (sessionRepo: SessionRepo) {
        self.sessionRepo = sessionRepo
    }

    func startWorkflow(router: Router) {
        if let token: String = sessionRepo.getToken() {
            router.showRestaurantListScreen()
        } else {
            router.showLoginScreen()
        }
    }
}