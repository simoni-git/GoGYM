//
//  오류수정내용.swift
//  myGYMapp
//
//  Created by MAC on 11/8/23.
//

import Foundation

/*
 
 수정전상황: 각 VC 마다 값을 입력하고나서 KindVC 로 오면 각 부위들의 토탈값들이 저장이 되긴했으나
         그이후에 KindVC 에서 외부로 나갔다가오면 KindVC 에 저장된값들이 다 날아가는상황이 생겼음.
         각 부위별VC 에는 값들이 여전히 남아있었음
 
 수정후상황: 각 부위별VC 와 KindVC 랑의 차이점을보니 save 와 load 를 각각 viewWillDisapear 과 viewDidLoad 부분에 작성해주줬는데 KindVC 에는 그런구현이 없었음. 그래서 KindVC 에있는 값들도 마찬가지로 userDefaults 에 저장하고 로드하는 과정을 해줬더니 해결됨.
 */


/*
 
 수정전상황: finishVC 에서 저장버튼을 누르지않고 앱사용도중에 나갔다가 들어오면 아무것도 건들지 않았어도 흔적이 남았었음. 이게 반복되면 각부위VC 에 나오는 값들이 -- 에서 0.0 으로 바껴서 나오는게 싫었고 메모리누적도될까봐 앱이 완전히 종료되면 저장버튼을누르지않아도 userDefaults 들이 지워지게하고싶었음.
 
 수정후상황: applicationWillTerminate 메서드에 앱의 모든 userDefaults 의 내용을 지워주는 메서드를 작성했더니 해결됨.
 */
