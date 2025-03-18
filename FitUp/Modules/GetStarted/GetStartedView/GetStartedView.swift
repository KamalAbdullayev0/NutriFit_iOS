import UIKit

class GetStartedView: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private let viewModel: GetStartedViewModel
    private let pageViewController: UIPageViewController
    
    private let texts = [
        "\"Fuel Your Body, Find Your Balance\" Discover personalized keto diets and health calculators tailored to your goals. Whether it's body fat, metabolism, or calorie intake NutriFit guides you every step of the way to a healthier, more balanced you",
        
        "\"Move More, Explore Better\" Find nearby sports salons and fitness centers with just a tap! NutriFit's smart map ensures you stay active and reach your fitness goals, no matter where you are.",
        
        "\"Your Health, Our Chatbot's Mission\" Got questions? NutriFit's AI-powered chatbot is here to support you 24/7 with personalized answers to keep your health journey on track. Ask away, and let the transformation begin!"
    ]
    
    private var currentIndex = 0
    private var timer: Timer?
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor(white: 1.0, alpha: 0.5)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    init(viewModel: GetStartedViewModel) {
        self.viewModel = viewModel
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let logotextView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "yazi")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let signUpButton = ButtonAuth(
        title: "Login",
        height: 60,
        textColor: .white,
        backgroundColor: Resources.Colors.background,
        fontSize: 20
    ) {
        print("basdun")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resources.Colors.background
        
        setupPageViewController()
        setupUI()
        startAutoScroll()
        for familyName in UIFont.familyNames {
            print("Family: \(familyName)")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print("Font: \(fontName)")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoScroll()
    }
    
    private func setupPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstVC = createTextViewController(for: currentIndex) {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true)
        }
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.addSubview(logoImageView)
        view.addSubview(logotextView)
        view.addSubview(signUpButton)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.topAnchor,constant: 180),
            logoImageView.widthAnchor.constraint(equalToConstant: 180),
            logoImageView.heightAnchor.constraint(equalToConstant: 180),
            
            logotextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logotextView.bottomAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 64),
            logotextView.widthAnchor.constraint(equalToConstant: 280),
            logotextView.heightAnchor.constraint(equalToConstant: 56),
            
            pageViewController.view.topAnchor.constraint(equalTo: logotextView.topAnchor, constant: 160),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pageViewController.view.heightAnchor.constraint(equalToConstant: 120),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
            
        ])
    }
    
    private func setupUI() {
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func createTextViewController(for index: Int) -> UIViewController? {
        guard index >= 0 && index < texts.count else { return nil }
        
        let textVC = UIViewController()
        let label = UILabel()
        label.text = texts[index]
        label.font = Resources.AppFont.medium.withSize(14)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        textVC.view.addSubview(label)
        textVC.view.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: textVC.view.leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: textVC.view.trailingAnchor, constant: -30),
            label.centerYAnchor.constraint(equalTo: textVC.view.centerYAnchor)
        ])
        
        return textVC
    }
    
    private func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.goToNextPage()
        }
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    private func goToNextPage() {
        currentIndex = (currentIndex + 1) % texts.count
        if let nextVC = createTextViewController(for: currentIndex) {
            pageViewController.setViewControllers([nextVC], direction: .forward, animated: true)
            pageControl.currentPage = currentIndex
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousIndex = (currentIndex - 1 + texts.count) % texts.count
        return createTextViewController(for: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextIndex = (currentIndex + 1) % texts.count
        return createTextViewController(for: nextIndex)
    }
}
