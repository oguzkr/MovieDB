//
//  ApiClient.swift
//  MovieDB
//
//  Created by Oğuz Karatoruk on 30.06.2021.
//

import Foundation
import Alamofire
import SVProgressHUD

class networkManager {
    
    
    var movies = [MovieInfoModel]()
    
    func BaseApi(pageId: Int) -> String{
        let Api = "\(Credential.BaseApi)\(Credential.SelectedLang)\(Credential.ApiKey)&page=\(pageId)"
        return Api
    }
    
    func getMovies(page: Int, completed: @escaping (_ success: Bool) -> ()){
        SVProgressHUD.show()
        AF.request(BaseApi(pageId: page), method: .get).responseData { response in
            switch response.result {
            case .failure(let error):
                print(error)
                completed(false)
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(MovieInfoModel.self, from: data)
                    self.movies = [result]
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        completed(true)
                    }
                } catch let error {
                    print(error)
                    completed(false)
                    SVProgressHUD.dismiss()
                }
            }
        }.resume()
    }
}
