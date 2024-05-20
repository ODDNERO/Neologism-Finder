//
//  NeologismViewController.swift
//  NeologismFinder
//
//  Created by NERO on 5/19/24.
//

import UIKit

class NeologismViewController: UIViewController {
    @IBOutlet var searchBarView: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchButton: UIButton!
    
    @IBOutlet var resultImageView: UIImageView!
    @IBOutlet var resultLabel: UILabel!
    
    let wordDict: [String: String] =
    ["삼귀다": "아직 사귀는 사이가 아닌 썸 타는 단계",
     "꾸안꾸": """
            "꾸민 듯 안 꾸민 듯"
            내추럴하지만 스타일리시한 느낌
            """,
     "좋못사": "좋아하다 못해 사랑함",
     "스불재": """
            "스스로 불러온 재앙"
            자신이 계획한 일로 자신이 고통받을 때
            """,
     "손민수하다": """
                "따라 하다"
                손민수는 '치즈인더트랩'에서
                주인공인 홍설을 따라 하는 캐릭터이다
                """,
     "복복복": """
            쓰다듬는 소리
            복복복 🫳🏻🫳🏻🫳🏻🫳🏻🫳🏻
            """,
     "잼얘": "재미있는 이야기",
     "쌉파서블": """
            쌉 + possible
            완전 가능한
            """
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.delegate = self
        
        setSearchBarView()
        setResultView()
        setWordScrollView()
        
        searchButton.addTarget(self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside)
    }
}

extension NeologismViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        searchWordResult()
        return true
    }
    
    @objc func searchButtonTapped(_ sender: UIButton) {
        searchTextField.resignFirstResponder()
        searchWordResult()
    }
}

extension NeologismViewController {
    func setSearchBarView() {
        searchBarView.frame.size = CGSize(width: 303, height: 45)
        searchBarView.layer.borderWidth = 2
        searchBarView.layer.borderColor = UIColor.black.cgColor
        
        searchTextField.backgroundColor = .clear
        searchTextField.borderStyle = .none
        searchTextField.textColor = .black
        searchTextField.tintColor = .black
        searchTextField.font = .systemFont(ofSize: 15)
        
        let searchImageSize = UIImage.SymbolConfiguration(scale: .medium)
        let serachImage = UIImage(systemName: "magnifyingglass", withConfiguration: searchImageSize)
        searchButton.setImage(serachImage, for: .normal)
        searchButton.tintColor = .white
        searchButton.backgroundColor = .black
    }
    
    func setResultView() {
        resultImageView.image = .background
        resultImageView.contentMode = .scaleAspectFill
        
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 18)
        resultLabel.textColor = .black
        resultLabel.numberOfLines = 0
    }
    
    func setWordScrollView() {
        let wordScrollView = UIScrollView()
        wordScrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(wordScrollView)

        wordScrollView.translatesAutoresizingMaskIntoConstraints = false
        wordScrollView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        wordScrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 133).isActive = true
        wordScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 45).isActive = true
        wordScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 45).isActive = true
        
        setwordButtonStackView(scrollView: wordScrollView)
    }
    
    func setwordButtonStackView(scrollView: UIScrollView) {
        let wordButtonStackView = UIStackView()
        wordButtonStackView.axis = .horizontal
        wordButtonStackView.backgroundColor = .clear
        wordButtonStackView.distribution = .equalSpacing
        wordButtonStackView.spacing = 4
        scrollView.addSubview(wordButtonStackView)
        
        wordButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        wordButtonStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        wordButtonStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        
        setWordButton(scrollView: scrollView, stackView: wordButtonStackView)
        
        wordButtonStackView.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.widthAnchor).isActive = true
    }
}

extension NeologismViewController {
    func setWordButton(scrollView: UIScrollView, stackView: UIStackView) {
        var totalButtonWidth: CGFloat = 0
        
        for word in wordDict.keys {
            let wordButton = UIButton()
            
            let titleSize = (word as NSString).size(withAttributes: [.font: wordButton.titleLabel!.font!])
            let buttonWidth = titleSize.width + 4
            wordButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            totalButtonWidth += buttonWidth
            
            wordButton.setTitle(word, for: .normal)
            wordButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
            wordButton.setTitleColor(.black, for: .normal)
            wordButton.titleLabel?.numberOfLines = 1
            
            wordButton.backgroundColor = .clear
            wordButton.layer.borderColor = UIColor.black.cgColor
            wordButton.layer.borderWidth = 1
            wordButton.layer.cornerRadius = 9
            
            wordButton.addTarget(self, action: #selector(wordButtonTapped(_:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(wordButton)
        }
        
        scrollView.contentSize = CGSize(width: totalButtonWidth + 100, height: stackView.frame.height)
    }
    
    @objc func wordButtonTapped(_ sender: UIButton) {
        guard let wordKey = sender.titleLabel?.text else {
            return
        }
        
        searchTextField.text = wordKey
        resultLabel.text = wordDict[wordKey]
    }
    
    func searchWordResult() {
        guard let searchWord = searchTextField.text, !searchWord.isEmpty else {
            resultLabel.text = "검색할 단어를 입력해 주세요."
            return
        }
        
        if let wordValue = wordDict[searchWord] {
            resultLabel.text = wordValue
        } else {
            resultLabel.text = "\(searchWord)에 대한 검색 결과가 없습니다."
        }
    }
}
