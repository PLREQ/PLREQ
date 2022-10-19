//
//  MatchViewController.swift
//  PLREQ
//
//  Created by 이영준 on 2022/09/27.
//

import UIKit
import ShazamKit
import CoreLocation

class MatchViewController: UIViewController {
    
    //MARK: Variabales
    var recordedMusicList = [Music]() {
        didSet {
            self.noRecordedMusicLabel.isHidden = self.recordedMusicList.isEmpty ? false : true
        }
    }
    // 임시 Image URL 추가
    var recordedMusic = Music(title: "", artist: "", musicImageURL: URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music128/v4/46/e3/8c/46e38c01-05a5-5787-af4b-593dde5ba586/8809550047556.jpg/800x800bb.jpg")!)
    var viewModel: MatchViewModel?
    var isListening: Bool = false
    var timer: Timer?
    let playListViewController: PlayListViewController = {
        let storyBoard = UIStoryboard(name: "PlayListView", bundle: nil)
        guard let playListViewController = storyBoard.instantiateViewController(withIdentifier: "PlayListView") as? PlayListViewController else { return UIViewController() as! PlayListViewController }
        return playListViewController
    }()
    let locationManager = CLLocationManager()
    var currentTime: String = ""
    var currentLocation: String = ""
    var currentLatitude: CLLocationDegrees = 0.0
    var currentLongtitude: CLLocationDegrees = 0.0
    
    //MARK: IBOutlet Variable
    @IBOutlet weak var playListButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var matchMusicCollectionView: UICollectionView!
    @IBOutlet weak var noRecordedMusicLabel: UILabel!
    
    //MARK: IBOutlet Function
    @IBAction func tapRecordButton(_ sender: UIButton) {
        self.isListening.toggle()
        if self.isListening {
            // 30초 동안 한번씩 songSearch 함수 실행
            timer = Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(catchMusic), userInfo: nil, repeats: false)
            timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(catchMusic), userInfo: nil, repeats: true)
        } else {
            if self.recordedMusicList.count == 0 {
                self.isEmptyRecordedMusicListAlert()
            } else {
                self.saveRecordedMusicList()
            }
        }
    }
    
    @IBAction func tapPlayListButton(_ sender: UIButton) {
        self.navigationController?.pushViewController(self.playListViewController, animated: true)
    }
    
    @objc func catchMusic() {
        do {
            try self.viewModel?.songSearch()
            self.locationManager.stopUpdatingLocation()
        } catch {
            print("error")
        }
    }
    
    //MARK: View Lifecycle Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleFunction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.viewModel == nil {
            self.viewModel = MatchViewModel(matchHandler: songMatched)
        }
        self.locationManager.startUpdatingLocation()
    }
    
    //MARK: Style Function
    private func styleFunction() {
        self.configureCollectionView()
        self.configureLocationManager()
        self.configureNoRecordedMusicLabel()
    }
    
    private func configureCollectionView() {
        self.view.backgroundColor = .black
        self.matchMusicCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.matchMusicCollectionView.backgroundColor = UIColor.black
        self.matchMusicCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.matchMusicCollectionView.delegate = self
        self.matchMusicCollectionView.dataSource = self
    }
    
    private func configureLocationManager() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    private func configureNoRecordedMusicLabel() {
        self.noRecordedMusicLabel.text = "하단의 버튼을 눌러 음악을 찾아보세요."
        self.noRecordedMusicLabel.textColor = .white
        self.noRecordedMusicLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
    }
    
    //MARK: Shazam Function
    private func songMatched(item: SHMatchedMediaItem?, error: Error?) {
        if error != nil {
            self.viewModel?.status = false
        } else {
            self.viewModel?.status = true
            
            // 동일한 타이틀, 아티스트의 음악이 이미 배열에 있는 경우 추가하지 않고 함수 종료
            for music in recordedMusicList {
                if music.title == item?.title && music.artist == item?.artist {
                    return
                }
            }
            self.viewModel?.title = item?.title
            self.viewModel?.artist = item?.artist
            self.viewModel?.musicImageURL = item?.artworkURL
            self.viewDraw()
        }
    }
    
    private func viewDraw() {
        self.recordedMusic.title = self.viewModel?.title ?? ""
        self.recordedMusic.artist = self.viewModel?.artist ?? ""
        self.recordedMusic.musicImageURL = self.viewModel?.musicImageURL ?? URL(string: "https://is3-ssl.mzstatic.com/image/thumb/Music128/v4/46/e3/8c/46e38c01-05a5-5787-af4b-593dde5ba586/8809550047556.jpg/800x800bb.jpg")!
        
        self.recordedMusicList.insert(self.recordedMusic, at: 0)
        self.matchMusicCollectionView.reloadData()
    }
    
    private func isEmptyRecordedMusicListAlert() {
        let alert = UIAlertController(title: "검색된 음악이 없습니다.", message: "", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(confirm)
        
        self.present(alert, animated: true)
    }
    
    private func saveRecordedMusicList() {
        let alert = UIAlertController(title: "재생 목록 저장", message: nil, preferredStyle: .alert)
        
        let registerButton = UIAlertAction(title: "저장", style: .default, handler: { _ in
            guard let title = alert.textFields?[0].text else { return }
            let firstImageURL = self.recordedMusicList[0].musicImageURL
            let secondImageURL = self.recordedMusicList[1].musicImageURL
            let thirdImageURL = self.recordedMusicList[2].musicImageURL
            let fourthImageURL = self.recordedMusicList[3].musicImageURL

            PLREQDataManager.shared.save(title: title, location: self.currentLocation, day: Date(), latitude: Float(self.currentLatitude), longtitude: Float(self.currentLongtitude), firstImageURL: firstImageURL, secondImageURL: secondImageURL, thirdImageURL: thirdImageURL, fourthImageURL: fourthImageURL, musics: self.recordedMusicList)
            self.recordedMusicList = [Music]()
            self.matchMusicCollectionView.reloadData()
            self.navigationController?.pushViewController(self.playListViewController, animated: true)
        })
        
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: { _ in
            alert.dismiss(animated: true)
        })
                                         
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        alert.addTextField(configurationHandler: { textField in
            self.currentTimeFormatter(.now)
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                textField.text = "\(self.currentLocation)에서의 " + "\(self.currentTime)"
            case .denied, .notDetermined, .restricted:
                textField.text = ""
            default:
                textField.placeholder = ""
            }
        })
        self.present(alert, animated: true)
    }
    
    private func currentTimeFormatter(_ date: Date) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH"
        let currentHour: String = timeFormatter.string(from: date)
        
        if Int(currentHour) ?? 0 < 6 {
            self.currentTime = "시원한 새벽"
        } else if Int(currentHour) ?? 0 < 12 {
            self.currentTime = "산뜻한 아침"
        } else if Int(currentHour) ?? 0 < 18 {
            self.currentTime = "나른한 오후"
        } else {
            self.currentTime = "적적한 저녁"
        }
    }
}

extension MatchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recordedMusicList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.matchMusicCollectionView.dequeueReusableCell(withReuseIdentifier: "MatchMusicCell", for: indexPath) as? MatchMusicCell else { return UICollectionViewCell() }
        let music = self.recordedMusicList[indexPath.row]
        cell.musicTitle.text = music.title
        cell.musicArtist.text = music.artist
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: music.musicImageURL)
            DispatchQueue.main.async {
                cell.musicImage.image = UIImage(data: data!)
            }
        }
        return cell
    }
}

extension MatchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.width - 10)
    }
}

extension MatchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLatitude = location.coordinate.latitude
            self.currentLongtitude = location.coordinate.longitude
            
            let findLocation = CLLocation(latitude: self.currentLatitude, longitude: self.currentLongtitude)
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "Ko-kr")
            geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { [weak self] (place, error) in
                if let address: [CLPlacemark] = place {
                    self?.currentLocation = "\(address.last?.locality ?? "")"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error \(error.localizedDescription)")
    }
}
