package com.mc.app.service;

import com.google.cloud.vision.v1.*;
import com.google.api.gax.core.FixedCredentialsProvider;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.protobuf.ByteString;

import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Slf4j
public class PetBreedAnalysisService {

    private static final Map<String, String> breedTranslationMap = new HashMap<>();
    private static final Map<String, Map<String, String>> breedCharacteristicsMap = new HashMap<>();

    static {
        // --- 품종 번역 맵 초기화 ---
        // --- 강아지 품종 (Dog Breeds) ---
        breedTranslationMap.put("retriever", "리트리버");
        breedTranslationMap.put("golden retriever", "골든 리트리버");
        breedTranslationMap.put("labrador retriever", "래브라도 리트리버");
        breedTranslationMap.put("flat-coated retriever", "플랫 코티드 리트리버");
        breedTranslationMap.put("curly-coated retriever", "컬리 코티드 리트리버");
        breedTranslationMap.put("chesapeake bay retriever", "체서피크 베이 리트리버");

        breedTranslationMap.put("bulldog", "불도그");
        breedTranslationMap.put("french bulldog", "프렌치 불도그");
        breedTranslationMap.put("english bulldog", "잉글리시 불도그");
        breedTranslationMap.put("american bulldog", "아메리칸 불도그");
        breedTranslationMap.put("olde english bulldogge", "올드 잉글리시 불도그");
        breedTranslationMap.put("australian bulldog", "오스트레일리안 불도그");

        breedTranslationMap.put("terrier", "테리어");
        breedTranslationMap.put("yorkshire terrier", "요크셔 테리어");
        breedTranslationMap.put("jack russell terrier", "잭 러셀 테리어");
        breedTranslationMap.put("bull terrier", "불 테리어");
        breedTranslationMap.put("staffordshire bull terrier", "스태퍼드셔 불 테리어");
        breedTranslationMap.put("american staffordshire terrier", "아메리칸 스태퍼드셔 테리어");
        breedTranslationMap.put("pit bull terrier", "핏불 테리어");
        breedTranslationMap.put("scottish terrier", "스코티시 테리어");
        breedTranslationMap.put("west highland white terrier", "웨스트 하일랜드 화이트 테리어");
        breedTranslationMap.put("cairn terrier", "케언 테리어");
        breedTranslationMap.put("airedale terrier", "에어데일 테리어");
        breedTranslationMap.put("fox terrier", "폭스 테리어");
        breedTranslationMap.put("wire fox terrier", "와이어 폭스 테리어");
        breedTranslationMap.put("smooth fox terrier", "스무스 폭스 테리어");
        breedTranslationMap.put("boston terrier", "보스턴 테리어");
        breedTranslationMap.put("small terrier", "소형 테리어");

        breedTranslationMap.put("poodle", "푸들");
        breedTranslationMap.put("toy poodle", "토이 푸들");
        breedTranslationMap.put("miniature poodle", "미니어처 푸들");
        breedTranslationMap.put("standard poodle", "스탠더드 푸들");

        breedTranslationMap.put("beagle", "비글");
        breedTranslationMap.put("beagle-harrier", "비글 해리어");
        breedTranslationMap.put("dachshund", "닥스훈트");
        breedTranslationMap.put("shiba inu", "시바견");
        breedTranslationMap.put("maltese", "말티즈");
        breedTranslationMap.put("pomeranian", "포메라니안");

        breedTranslationMap.put("german shepherd", "저먼 셰퍼드");
        breedTranslationMap.put("old german shepherd dog", "올드 저먼 셰퍼드 도그");
        breedTranslationMap.put("king shepherd", "킹 셰퍼드");
        breedTranslationMap.put("belgian malinois", "벨지안 말리노이즈");
        breedTranslationMap.put("belgian tervuren", "벨지안 테뷰런");

        breedTranslationMap.put("siberian husky", "시베리안 허스키");
        breedTranslationMap.put("alaskan malamute", "알래스칸 맬러뮤트");
        breedTranslationMap.put("alaskan klee kai", "알래스칸 클리카이");

        breedTranslationMap.put("welsh corgi", "웰시 코기");
        breedTranslationMap.put("pembroke welsh corgi", "펨브록 웰시 코기");
        breedTranslationMap.put("cardigan welsh corgi", "카디건 웰시 코기");

        breedTranslationMap.put("boxer", "복서");
        breedTranslationMap.put("doberman pinscher", "도베르만 핀셔");
        breedTranslationMap.put("rottweiler", "로트와일러");
        breedTranslationMap.put("great dane", "그레이트 데인");
        breedTranslationMap.put("bernese mountain dog", "버니즈 마운틴 도그");
        breedTranslationMap.put("northern inuit dog", "노던 이누이트 도그");
        breedTranslationMap.put("greater swiss mountain dog", "그레이터 스위스 마운틴 도그");

        breedTranslationMap.put("australian shepherd", "오스트레일리안 셰퍼드");
        breedTranslationMap.put("australian cattle dog", "오스트레일리안 캐틀 도그");
        breedTranslationMap.put("australian kelpie", "오스트레일리안 켈피");

        breedTranslationMap.put("collie", "콜리");
        breedTranslationMap.put("border collie", "보더 콜리"); 
        breedTranslationMap.put("rough collie", "러프 콜리"); 
        breedTranslationMap.put("smooth collie", "스무스 콜리"); 
        breedTranslationMap.put("shetland sheepdog", "셔틀랜드 쉽독"); 

        breedTranslationMap.put("spaniel", "스패니얼");
        breedTranslationMap.put("cocker spaniel", "코커 스패니얼"); 
        breedTranslationMap.put("english springer spaniel", "잉글리시 스프링어 스패니얼"); 
        breedTranslationMap.put("welsh springer spaniel", "웰시 스프링어 스패니얼"); 
        breedTranslationMap.put("brittany spaniel", "브리트니 스패니얼"); 
        breedTranslationMap.put("king charles spaniel", "킹 찰스 스패니얼"); 
        breedTranslationMap.put("cavalier king charles spaniel", "카발리에 킹 찰스 스패니얼");

        breedTranslationMap.put("chihuahua", "치와와");
        breedTranslationMap.put("pug", "퍼그");
        breedTranslationMap.put("bichon frise", "비숑 프리제"); 
        breedTranslationMap.put("bichon", "비숑"); 
        breedTranslationMap.put("bolognese dog", "볼로네즈 도그");
        breedTranslationMap.put("havanese", "하바네즈");
        breedTranslationMap.put("coton de tulear", "꼬통 드 툴레아");
        breedTranslationMap.put("shih tzu", "시츄");
        breedTranslationMap.put("lhasa apso", "라사 압소");
        breedTranslationMap.put("tibetan terrier", "티베탄 테리어");
        breedTranslationMap.put("tibetan spaniel", "티베탄 스패니얼");

        breedTranslationMap.put("akita", "아키타");
        breedTranslationMap.put("japanese akita", "재패니즈 아키타");
        breedTranslationMap.put("american akita", "아메리칸 아키타");
        breedTranslationMap.put("samoyed", "사모예드");
        breedTranslationMap.put("eurasier", "유라시어");
        breedTranslationMap.put("keeshond", "키스혼드");

        breedTranslationMap.put("greyhound", "그레이하운드");
        breedTranslationMap.put("whippet", "휘핏");
        breedTranslationMap.put("italian greyhound", "이탈리안 그레이하운드");
        breedTranslationMap.put("saluki", "살루키");
        breedTranslationMap.put("afghan hound", "아프간 하운드");
        breedTranslationMap.put("american foxhound", "아메리칸 폭스하운드");
        breedTranslationMap.put("borzoi", "보르조이");
        breedTranslationMap.put("basenji", "바센지");

        breedTranslationMap.put("dalmatian", "달마시안");
        breedTranslationMap.put("pointer", "포인터");
        breedTranslationMap.put("german shorthaired pointer", "저먼 쇼트헤어드 포인터");
        breedTranslationMap.put("german wirehaired pointer", "저먼 와이어헤어드 포인터");
        breedTranslationMap.put("setter", "세터");
        breedTranslationMap.put("irish setter", "아이리시 세터");
        breedTranslationMap.put("english setter", "잉글리시 세터");
        breedTranslationMap.put("gordon setter", "고든 세터");

        breedTranslationMap.put("weimaraner", "바이마라너");
        breedTranslationMap.put("vizsla", "비즐라");
        breedTranslationMap.put("rhodesian ridgeback", "로디지안 리지백"); 

        breedTranslationMap.put("newfoundland", "뉴펀들랜드");
        breedTranslationMap.put("landseer", "랜드시어");
        breedTranslationMap.put("st. bernard", "세인트 버나드");
        breedTranslationMap.put("leonberger", "레온베르거");

        breedTranslationMap.put("mastiff", "마스티프");
        breedTranslationMap.put("bullmastiff", "불마스티프");
        breedTranslationMap.put("neapolitan mastiff", "나폴리탄 마스티프");
        breedTranslationMap.put("tibetan mastiff", "티베탄 마스티프");
        breedTranslationMap.put("cane corso", "카네 코르소");
        breedTranslationMap.put("dogue de bordeaux", "도그 드 보르도");

        breedTranslationMap.put("schnauzer", "슈나우저");
        breedTranslationMap.put("miniature schnauzer", "미니어처 슈나우저");
        breedTranslationMap.put("standard schnauzer", "스탠더드 슈나우저");
        breedTranslationMap.put("giant schnauzer", "자이언트 슈나우저");

        breedTranslationMap.put("papillon", "파피용");
        breedTranslationMap.put("phalene", "팔렌");

        breedTranslationMap.put("jindo", "진돗개"); 
        breedTranslationMap.put("poongsan", "풍산개");
        breedTranslationMap.put("sapsali", "삽살개");

        // 일반 강아지 관련 용어
        breedTranslationMap.put("dog", "강아지");
        breedTranslationMap.put("puppy", "강아지");
        breedTranslationMap.put("canine", "개과 동물");
        breedTranslationMap.put("gun dog", "조렵견");
        breedTranslationMap.put("herding dog", "목축견"); 
        breedTranslationMap.put("sled dog", "썰매견"); 
        breedTranslationMap.put("water dog", "워터 도그"); 
        breedTranslationMap.put("toy dog", "토이 도그 (소형견)");
        breedTranslationMap.put("poodle crossbreed", "푸들 믹스견");
        breedTranslationMap.put("dog collar", "개 목걸이");
        breedTranslationMap.put("dog supply", "애견 용품");
        breedTranslationMap.put("pet supply", "반려동물 용품");

        // --- 고양이 품종 (Cat Breeds) ---
        breedTranslationMap.put("persian", "페르시안");
        breedTranslationMap.put("siamese", "샴");
        breedTranslationMap.put("ragdoll", "랙돌");
        breedTranslationMap.put("bengal", "벵갈");
        breedTranslationMap.put("british shorthair", "브리티시 쇼트헤어"); 
        breedTranslationMap.put("british longhair", "브리티시 롱헤어"); 
        breedTranslationMap.put("scottish fold", "스코티시 폴드"); 
        breedTranslationMap.put("scottish straight", "스코티시 스트레이트"); 
        breedTranslationMap.put("norwegian forest cat", "노르웨이 숲 고양이"); 
        breedTranslationMap.put("russian blue", "러시안 블루"); 
        breedTranslationMap.put("russian white", "러시안 화이트"); 
        breedTranslationMap.put("russian black", "러시안 블랙"); 
        breedTranslationMap.put("bengal cat", "벵갈 고양이"); 
        breedTranslationMap.put("siamese cat", "샴 고양이"); 
        breedTranslationMap.put("thai cat", "타이 고양이"); 
        breedTranslationMap.put("balinese cat", "발리니즈 고양이"); 
        breedTranslationMap.put("asian semi-longhair", "아시안 세미 롱헤어"); 
        breedTranslationMap.put("munchkin cat", "먼치킨 고양이");

        breedTranslationMap.put("maine coon", "메인쿤");
        breedTranslationMap.put("sphynx", "스핑크스");
        breedTranslationMap.put("peterbald", "피터볼드");
        breedTranslationMap.put("donskoy", "돈스코이");

        breedTranslationMap.put("abyssinian", "아비시니안");
        breedTranslationMap.put("birman", "버만");
        breedTranslationMap.put("oriental shorthair", "오리엔탈 쇼트헤어"); 
        breedTranslationMap.put("oriental longhair", "오리엔탈 롱헤어");
        breedTranslationMap.put("exotic shorthair", "엑조틱 쇼트헤어"); 
        breedTranslationMap.put("burmese", "버미즈");
        breedTranslationMap.put("european burmese", "유러피안 버미즈");

        breedTranslationMap.put("american shorthair", "아메리칸 쇼트헤어"); 
        breedTranslationMap.put("american wirehair", "아메리칸 와이어헤어"); 
        breedTranslationMap.put("american curl", "아메리칸 컬"); 
        breedTranslationMap.put("japanese bobtail", "재패니즈 밥테일"); 
        breedTranslationMap.put("kurilian bobtail", "쿠릴리안 밥테일");

        breedTranslationMap.put("devon rex", "데본 렉스"); 
        breedTranslationMap.put("cornish rex", "코니시 렉스");
        breedTranslationMap.put("selkirk rex", "셀커크 렉스");
        breedTranslationMap.put("german rex", "저먼 렉스");

        breedTranslationMap.put("turkish angora", "터키시 앙고라"); 
        breedTranslationMap.put("turkish van", "터키시 반"); 
        breedTranslationMap.put("manx", "맹크스");
        breedTranslationMap.put("cymric", "킴릭");
        breedTranslationMap.put("balinese", "발리니즈");
        breedTranslationMap.put("javanese", "자바니즈");
        breedTranslationMap.put("colorpoint shorthair", "컬러포인트 쇼트헤어"); 
        breedTranslationMap.put("himalayan", "히말라얀");
        breedTranslationMap.put("somali", "소말리");
        breedTranslationMap.put("ocicat", "오시캣");
        breedTranslationMap.put("egyptian mau", "이집션 마우");
        breedTranslationMap.put("chartreux", "샤르트뢰");
        breedTranslationMap.put("korat", "코랫");
        breedTranslationMap.put("singapura", "싱가푸라");
        breedTranslationMap.put("tonkinese", "통키니즈");
        breedTranslationMap.put("bombay", "봄베이");
        breedTranslationMap.put("havana brown", "하바나 브라운");
        breedTranslationMap.put("snowshoe", "스노우슈");
        breedTranslationMap.put("ragamuffin", "랙아머핀");
        breedTranslationMap.put("nebelung", "네벨룽");
        breedTranslationMap.put("laperm", "라팜");
        breedTranslationMap.put("munchkin", "먼치킨");
        breedTranslationMap.put("pixie-bob", "픽시밥");
        breedTranslationMap.put("serengeti", "세렝게티");
        breedTranslationMap.put("toyger", "토이거");
        breedTranslationMap.put("chausie", "쵸시");
        breedTranslationMap.put("savannah", "사바나");

        // 일반 고양이 관련 용어
        breedTranslationMap.put("korean short-hair", "코리안 쇼트헤어"); 
        breedTranslationMap.put("cat", "고양이");
        breedTranslationMap.put("kitten", "아기 고양이");
        breedTranslationMap.put("feline", "고양이과 동물");
        breedTranslationMap.put("tabby", "태비 (줄무늬 고양이)");
        breedTranslationMap.put("calico", "칼리코 (삼색 고양이)");
        breedTranslationMap.put("tortoiseshell", "톨토이즈쉘 (카오스 고양이)");
        breedTranslationMap.put("tuxedo", "턱시도 고양이");
        breedTranslationMap.put("domestic short-haired cat", "도메스틱 쇼트헤어 (집고양이)"); 
        breedTranslationMap.put("domestic long-haired cat", "도메스틱 롱헤어 (집고양이)");
        breedTranslationMap.put("mixed breed", "믹스견/믹스묘");
        breedTranslationMap.put("moggy", "믹스묘 (영국식)");
        breedTranslationMap.put("pet", "반려동물");
        breedTranslationMap.put("mixed breed", "믹스견/믹스묘");
        breedTranslationMap.put("white", "흰색 고양이");

        // --- 강아지 특징 (Retrievers, Bulldogs, Terriers) ---
        Map<String, String> goldenRetrieverChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "high", "temperament", "friendly, intelligent, devoted, outgoing");
        breedCharacteristicsMap.put("golden retriever", goldenRetrieverChars);
        breedCharacteristicsMap.put("retriever", goldenRetrieverChars); // 대표

        Map<String, String> labradorRetrieverChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "moderate", "temperament", "friendly, active, outgoing, gentle");
        breedCharacteristicsMap.put("labrador retriever", labradorRetrieverChars);

        Map<String, String> flatCoatedRetrieverChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "moderate", "temperament", "cheerful, optimistic, playful");
        breedCharacteristicsMap.put("flat-coated retriever", flatCoatedRetrieverChars);

        Map<String, String> curlyCoatedRetrieverChars = Map.of("size", "large", "activityLevel", "high",
                "groomingNeeds", "moderate", "temperament", "intelligent, proud, confident");
        breedCharacteristicsMap.put("curly-coated retriever", curlyCoatedRetrieverChars);

        Map<String, String> chesapeakeBayRetrieverChars = Map.of("size", "large", "activityLevel", "high",
                "groomingNeeds", "low", "temperament", "bright, happy, courageous, protective");
        breedCharacteristicsMap.put("chesapeake bay retriever", chesapeakeBayRetrieverChars);

        Map<String, String> frenchBulldogChars = Map.of("size", "small", "activityLevel", "low", "groomingNeeds", "low",
                "temperament", "playful, smart, adaptable, affectionate");
        breedCharacteristicsMap.put("french bulldog", frenchBulldogChars);
        breedCharacteristicsMap.put("bulldog", frenchBulldogChars); 

        Map<String, String> englishBulldogChars = Map.of("size", "medium", "activityLevel", "low", "groomingNeeds",
                "low", "temperament", "docile, willful, friendly, calm");
        breedCharacteristicsMap.put("english bulldog", englishBulldogChars);

        Map<String, String> americanBulldogChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "low", "temperament", "confident, friendly, assertive, loyal");
        breedCharacteristicsMap.put("american bulldog", americanBulldogChars);

        Map<String, String> oldeEnglishBulldoggeChars = Map.of("size", "large", "activityLevel", "moderate",
                "groomingNeeds", "low", "temperament", "confident, courageous, friendly, alert");
        breedCharacteristicsMap.put("olde english bulldogge", oldeEnglishBulldoggeChars);

        Map<String, String> australianBulldogChars = Map.of("size", "medium", "activityLevel", "moderate",
                "groomingNeeds", "low", "temperament", "loyal, friendly, confident");
        breedCharacteristicsMap.put("australian bulldog", australianBulldogChars);

        Map<String, String> yorkshireTerrierChars = Map.of("size", "small", "activityLevel", "high", "groomingNeeds",
                "high", "temperament", "feisty, brave, affectionate, energetic");
        breedCharacteristicsMap.put("yorkshire terrier", yorkshireTerrierChars);
        breedCharacteristicsMap.put("terrier", yorkshireTerrierChars); // 대표

        Map<String, String> jackRussellTerrierChars = Map.of("size", "small", "activityLevel", "very_high",
                "groomingNeeds", "low", "temperament", "energetic, intelligent, fearless, vocal");
        breedCharacteristicsMap.put("jack russell terrier", jackRussellTerrierChars);

        Map<String, String> bullTerrierChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "playful, charming, mischievous, loyal");
        breedCharacteristicsMap.put("bull terrier", bullTerrierChars);

        Map<String, String> staffordshireBullTerrierChars = Map.of("size", "medium", "activityLevel", "moderate",
                "groomingNeeds", "low", "temperament", "courageous, intelligent, affectionate, reliable");
        breedCharacteristicsMap.put("staffordshire bull terrier", staffordshireBullTerrierChars);

        Map<String, String> americanStaffordshireTerrierChars = Map.of("size", "medium", "activityLevel", "moderate",
                "groomingNeeds", "low", "temperament", "confident, good-natured, courageous, loyal");
        breedCharacteristicsMap.put("american staffordshire terrier", americanStaffordshireTerrierChars);

        Map<String, String> pitBullTerrierChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds",
                "low", "temperament", "confident, smart, eager to please, loyal"); 
        breedCharacteristicsMap.put("pit bull terrier", pitBullTerrierChars);

        Map<String, String> scottishTerrierChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "independent, confident, spirited, alert");
        breedCharacteristicsMap.put("scottish terrier", scottishTerrierChars);

        Map<String, String> westHighlandWhiteTerrierChars = Map.of("size", "small", "activityLevel", "moderate",
                "groomingNeeds", "high", "temperament", "friendly, happy, confident, alert");
        breedCharacteristicsMap.put("west highland white terrier", westHighlandWhiteTerrierChars);

        Map<String, String> cairnTerrierChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "cheerful, alert, busy, curious");
        breedCharacteristicsMap.put("cairn terrier", cairnTerrierChars);

        Map<String, String> airedaleTerrierChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "high", "temperament", "intelligent, outgoing, confident, friendly");
        breedCharacteristicsMap.put("airedale terrier", airedaleTerrierChars);

        Map<String, String> foxTerrierChars = Map.of("size", "small", "activityLevel", "high", "groomingNeeds",
                "moderate", "temperament", "alert, energetic, playful, fearless");
        breedCharacteristicsMap.put("fox terrier", foxTerrierChars);
        breedCharacteristicsMap.put("wire fox terrier", Map.of("size", "small", "activityLevel", "high",
                "groomingNeeds", "high", "temperament", "alert, energetic, playful, fearless"));
        breedCharacteristicsMap.put("smooth fox terrier", Map.of("size", "small", "activityLevel", "high",
                "groomingNeeds", "low", "temperament", "alert, energetic, playful, friendly"));

        Map<String, String> bostonTerrierChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds",
                "low", "temperament", "friendly, bright, amusing, adaptable");
        breedCharacteristicsMap.put("boston terrier", bostonTerrierChars);

        Map<String, String> smallTerrierChars = Map.of("size", "small", "activityLevel", "variable", "groomingNeeds",
                "variable", "temperament", "feisty, energetic, alert"); 
        breedCharacteristicsMap.put("small terrier", smallTerrierChars);

        // --- 강아지 특징 (Poodles, Beagles, Dachshunds, Spitz types etc.) ---
        Map<String, String> poodleChars = Map.of("size", "variable", "activityLevel", "high", "groomingNeeds", "high",
                "temperament", "intelligent, active, proud, trainable");
        breedCharacteristicsMap.put("poodle", poodleChars);
        breedCharacteristicsMap.put("toy poodle", Map.of("size", "small", "activityLevel", "high", "groomingNeeds",
                "high", "temperament", "intelligent, active, alert"));
        breedCharacteristicsMap.put("miniature poodle", Map.of("size", "medium", "activityLevel", "high",
                "groomingNeeds", "high", "temperament", "intelligent, active, trainable"));
        breedCharacteristicsMap.put("standard poodle", Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "high", "temperament", "intelligent, active, proud, good-natured"));
        breedCharacteristicsMap.put("poodle crossbreed", Map.of("size", "variable", "activityLevel", "variable",
                "groomingNeeds", "variable", "temperament", "variable, often intelligent and friendly")); // Mix

        Map<String, String> beagleChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "curious, friendly, merry, vocal");
        breedCharacteristicsMap.put("beagle", beagleChars);

        Map<String, String> beagleHarrierChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds",
                "low", "temperament", "determined, energetic, friendly");
        breedCharacteristicsMap.put("beagle-harrier", beagleHarrierChars);

        Map<String, String> dachshundChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds",
                "variable", "temperament", "clever, stubborn, playful, brave");
        breedCharacteristicsMap.put("dachshund", dachshundChars);

        Map<String, String> shibaInuChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "alert, active, independent, loyal");
        breedCharacteristicsMap.put("shiba inu", shibaInuChars);

        Map<String, String> malteseChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds", "high",
                "temperament", "gentle, playful, charming, fearless");
        breedCharacteristicsMap.put("maltese", malteseChars);

        Map<String, String> pomeranianChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "lively, bold, curious, intelligent");
        breedCharacteristicsMap.put("pomeranian", pomeranianChars);

        // --- 강아지 특징 (Shepherds, Huskies, Corgis) ---
        Map<String, String> germanShepherdChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "moderate", "temperament", "confident, courageous, smart, loyal");
        breedCharacteristicsMap.put("german shepherd", germanShepherdChars);
        breedCharacteristicsMap.put("shepherd", germanShepherdChars); 

        Map<String, String> oldGermanShepherdChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "high", "temperament", "loyal, intelligent, calm, protective"); 
        breedCharacteristicsMap.put("old german shepherd dog", oldGermanShepherdChars);

        Map<String, String> kingShepherdChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "intelligent, calm, loyal, protective"); 
        breedCharacteristicsMap.put("king shepherd", kingShepherdChars);

        Map<String, String> belgianMalinoisChars = Map.of("size", "large", "activityLevel", "very_high",
                "groomingNeeds", "low", "temperament", "confident, smart, hardworking, intense");
        breedCharacteristicsMap.put("belgian malinois", belgianMalinoisChars);

        Map<String, String> belgianTervurenChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "high", "temperament", "intelligent, courageous, alert, active");
        breedCharacteristicsMap.put("belgian tervuren", belgianTervurenChars);

        Map<String, String> siberianHuskyChars = Map.of("size", "large", "activityLevel", "very_high", "groomingNeeds",
                "moderate", "temperament", "friendly, outgoing, mischievous, energetic");
        breedCharacteristicsMap.put("siberian husky", siberianHuskyChars);
        breedCharacteristicsMap.put("husky", siberianHuskyChars); 

        Map<String, String> alaskanMalamuteChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "high", "temperament", "affectionate, loyal, playful, dignified");
        breedCharacteristicsMap.put("alaskan malamute", alaskanMalamuteChars);

        Map<String, String> alaskanKleeKaiChars = Map.of("size", "small", "activityLevel", "high", "groomingNeeds",
                "moderate", "temperament", "intelligent, curious, agile, alert");
        breedCharacteristicsMap.put("alaskan klee kai", alaskanKleeKaiChars);

        Map<String, String> northernInuitDogChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "moderate", "temperament", "friendly, intelligent, calm, non-aggressive"); 
        breedCharacteristicsMap.put("northern inuit dog", northernInuitDogChars);

        Map<String, String> welshCorgiChars = Map.of("size", "small", "activityLevel", "high", "groomingNeeds",
                "moderate", "temperament", "affectionate, smart, alert, outgoing");
        breedCharacteristicsMap.put("welsh corgi", welshCorgiChars); // 대표
        breedCharacteristicsMap.put("pembroke welsh corgi", Map.of("size", "small", "activityLevel", "high",
                "groomingNeeds", "moderate", "temperament", "affectionate, smart, alert, tenacious")); 
        breedCharacteristicsMap.put("cardigan welsh corgi", Map.of("size", "small", "activityLevel", "high",
                "groomingNeeds", "moderate", "temperament", "affectionate, loyal, smart, steady")); 

        // --- 강아지 특징 (Boxers, Dobermans, Rottweilers, Mountain Dogs, Australian breeds)
        // ---
        Map<String, String> boxerChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "bright, fun-loving, active, loyal");
        breedCharacteristicsMap.put("boxer", boxerChars);

        Map<String, String> dobermanPinscherChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "low", "temperament", "alert, fearless, loyal, intelligent");
        breedCharacteristicsMap.put("doberman pinscher", dobermanPinscherChars);

        Map<String, String> rottweilerChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "low", "temperament", "loyal, confident, courageous, calm");
        breedCharacteristicsMap.put("rottweiler", rottweilerChars);

        Map<String, String> greatDaneChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "low", "temperament", "friendly, patient, dependable, gentle giant");
        breedCharacteristicsMap.put("great dane", greatDaneChars);

        Map<String, String> berneseMountainDogChars = Map.of("size", "large", "activityLevel", "moderate",
                "groomingNeeds", "high", "temperament", "good-natured, calm, strong, affectionate");
        breedCharacteristicsMap.put("bernese mountain dog", berneseMountainDogChars);

        Map<String, String> greaterSwissMountainDogChars = Map.of("size", "large", "activityLevel", "moderate",
                "groomingNeeds", "low", "temperament", "faithful, dependable, alert, family-oriented");
        breedCharacteristicsMap.put("greater swiss mountain dog", greaterSwissMountainDogChars);

        Map<String, String> australianShepherdChars = Map.of("size", "medium", "activityLevel", "very_high",
                "groomingNeeds", "moderate", "temperament", "smart, work-oriented, exuberant, loyal");
        breedCharacteristicsMap.put("australian shepherd", australianShepherdChars);

        Map<String, String> australianCattleDogChars = Map.of("size", "medium", "activityLevel", "very_high",
                "groomingNeeds", "low", "temperament", "alert, curious, energetic, loyal");
        breedCharacteristicsMap.put("australian cattle dog", australianCattleDogChars);

        Map<String, String> australianKelpieChars = Map.of("size", "medium", "activityLevel", "very_high",
                "groomingNeeds", "low", "temperament", "intelligent, alert, eager, loyal");
        breedCharacteristicsMap.put("australian kelpie", australianKelpieChars);

        // --- 강아지 특징 (Collies, Spaniels) ---
        Map<String, String> collieChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds", "high",
                "temperament", "graceful, devoted, proud, intelligent");
        breedCharacteristicsMap.put("collie", collieChars);
        breedCharacteristicsMap.put("rough collie", collieChars);

        Map<String, String> borderCollieChars = Map.of("size", "medium", "activityLevel", "very_high", "groomingNeeds",
                "moderate", "temperament", "energetic, smart, athletic, workaholic");
        breedCharacteristicsMap.put("border collie", borderCollieChars);

        Map<String, String> smoothCollieChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "low", "temperament", "graceful, devoted, intelligent, trainable");
        breedCharacteristicsMap.put("smooth collie", smoothCollieChars);

        Map<String, String> shetlandSheepdogChars = Map.of("size", "small", "activityLevel", "high", "groomingNeeds",
                "high", "temperament", "playful, energetic, bright, loyal");
        breedCharacteristicsMap.put("shetland sheepdog", shetlandSheepdogChars);

        Map<String, String> cockerSpanielChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "gentle, smart, happy, affectionate");
        breedCharacteristicsMap.put("cocker spaniel", cockerSpanielChars);
        breedCharacteristicsMap.put("spaniel", cockerSpanielChars); 

        Map<String, String> englishSpringerSpanielChars = Map.of("size", "medium", "activityLevel", "high",
                "groomingNeeds", "moderate", "temperament", "friendly, playful, obedient, eager to please");
        breedCharacteristicsMap.put("english springer spaniel", englishSpringerSpanielChars);

        Map<String, String> welshSpringerSpanielChars = Map.of("size", "medium", "activityLevel", "high",
                "groomingNeeds", "moderate", "temperament", "happy, reserved (with strangers), loyal, active");
        breedCharacteristicsMap.put("welsh springer spaniel", welshSpringerSpanielChars);

        Map<String, String> brittanySpanielChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds",
                "low", "temperament", "bright, fun-loving, upbeat, eager");
        breedCharacteristicsMap.put("brittany spaniel", brittanySpanielChars);

        Map<String, String> kingCharlesSpanielChars = Map.of("size", "small", "activityLevel", "low", "groomingNeeds",
                "moderate", "temperament", "affectionate, gentle, graceful, quiet");
        breedCharacteristicsMap.put("king charles spaniel", kingCharlesSpanielChars);

        Map<String, String> cavalierKingCharlesSpanielChars = Map.of("size", "small", "activityLevel", "moderate",
                "groomingNeeds", "moderate", "temperament", "affectionate, gentle, graceful, friendly");
        breedCharacteristicsMap.put("cavalier king charles spaniel", cavalierKingCharlesSpanielChars);

        // --- 강아지 특징 (Chihuahuas, Pugs, Bichons, Small Companions) ---
        Map<String, String> chihuahuaChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds",
                "low", "temperament", "charming, graceful, sassy, loyal");
        breedCharacteristicsMap.put("chihuahua", chihuahuaChars);

        Map<String, String> pugChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds", "moderate",
                "temperament", "charming, mischievous, loving, playful");
        breedCharacteristicsMap.put("pug", pugChars);

        Map<String, String> bichonFriseChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "playful, curious, peppy, affectionate");
        breedCharacteristicsMap.put("bichon frise", bichonFriseChars);
        breedCharacteristicsMap.put("bichon", bichonFriseChars); // 대표

        Map<String, String> bologneseDogChars = Map.of("size", "small", "activityLevel", "low", "groomingNeeds", "high",
                "temperament", "calm, playful, devoted, easygoing");
        breedCharacteristicsMap.put("bolognese dog", bologneseDogChars);

        Map<String, String> havaneseChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "intelligent, outgoing, funny, cheerful");
        breedCharacteristicsMap.put("havanese", havaneseChars);

        Map<String, String> cotonDeTulearChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "charming, bright, happy-go-lucky, playful");
        breedCharacteristicsMap.put("coton de tulear", cotonDeTulearChars);

        Map<String, String> shihTzuChars = Map.of("size", "small", "activityLevel", "low", "groomingNeeds", "high",
                "temperament", "outgoing, affectionate, playful, charming");
        breedCharacteristicsMap.put("shih tzu", shihTzuChars);

        Map<String, String> lhasaApsoChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "confident, smart, comical, aloof (with strangers)");
        breedCharacteristicsMap.put("lhasa apso", lhasaApsoChars);

        Map<String, String> tibetanTerrierChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "smart, sensitive, adaptable, affectionate");
        breedCharacteristicsMap.put("tibetan terrier", tibetanTerrierChars);

        Map<String, String> tibetanSpanielChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "playful, bright, self-confident, independent");
        breedCharacteristicsMap.put("tibetan spaniel", tibetanSpanielChars);

        // --- 강아지 특징 (Akitas, Spitz types, Hounds) ---
        Map<String, String> akitaChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds", "high",
                "temperament", "courageous, dignified, profoundly loyal, wary (of strangers)");
        breedCharacteristicsMap.put("akita", akitaChars);
        breedCharacteristicsMap.put("japanese akita", akitaChars); 
        breedCharacteristicsMap.put("american akita", Map.of("size", "large", "activityLevel", "moderate",
                "groomingNeeds", "high", "temperament", "courageous, dignified, loyal, larger build"));

        Map<String, String> samoyedChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds", "high",
                "temperament", "gentle, adaptable, friendly, smiling");
        breedCharacteristicsMap.put("samoyed", samoyedChars);

        Map<String, String> eurasierChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "calm, confident, even-tempered, reserved (with strangers)");
        breedCharacteristicsMap.put("eurasier", eurasierChars);

        Map<String, String> keeshondChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "friendly, lively, outgoing, alert");
        breedCharacteristicsMap.put("keeshond", keeshondChars);

        Map<String, String> greyhoundChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "low", "temperament", "gentle, independent, noble, quiet (indoors)");
        breedCharacteristicsMap.put("greyhound", greyhoundChars);

        Map<String, String> whippetChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds", "low",
                "temperament", "affectionate, playful, calm (indoors), quiet");
        breedCharacteristicsMap.put("whippet", whippetChars);

        Map<String, String> italianGreyhoundChars = Map.of("size", "small", "activityLevel", "moderate",
                "groomingNeeds", "low", "temperament", "playful, alert, sensitive, affectionate");
        breedCharacteristicsMap.put("italian greyhound", italianGreyhoundChars);

        Map<String, String> salukiChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "gentle, dignified, reserved (with strangers), independent");
        breedCharacteristicsMap.put("saluki", salukiChars);

        Map<String, String> afghanHoundChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "very_high", "temperament", "dignified, aloof, independent, comical");
        breedCharacteristicsMap.put("afghan hound", afghanHoundChars);

        Map<String, String> americanFoxhoundChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "low", "temperament", "easygoing, sweet-tempered, independent, vocal");
        breedCharacteristicsMap.put("american foxhound", americanFoxhoundChars);
        breedCharacteristicsMap.put("foxhound", americanFoxhoundChars); 

        Map<String, String> borzoiChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "regal, calm, affectionate, independent");
        breedCharacteristicsMap.put("borzoi", borzoiChars);

        Map<String, String> basenjiChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "independent, smart, poised, barkless (but makes other sounds)");
        breedCharacteristicsMap.put("basenji", basenjiChars);

        // --- 강아지 특징 (Dalmatians, Pointers, Setters, Weimaraners, Ridgebacks) ---
        Map<String, String> dalmatianChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "moderate", "temperament", "dignified, smart, outgoing, energetic");
        breedCharacteristicsMap.put("dalmatian", dalmatianChars);

        Map<String, String> pointerChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "even-tempered, hardworking, loyal, intelligent");
        breedCharacteristicsMap.put("pointer", pointerChars); 

        Map<String, String> germanShorthairedPointerChars = Map.of("size", "large", "activityLevel", "very_high",
                "groomingNeeds", "low", "temperament", "friendly, smart, willing to please, enthusiastic");
        breedCharacteristicsMap.put("german shorthaired pointer", germanShorthairedPointerChars);

        Map<String, String> germanWirehairedPointerChars = Map.of("size", "large", "activityLevel", "very_high",
                "groomingNeeds", "moderate", "temperament",
                "affectionate, eager, enthusiastic, weather-resistant coat");
        breedCharacteristicsMap.put("german wirehaired pointer", germanWirehairedPointerChars);

        Map<String, String> irishSetterChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds", "high",
                "temperament", "outgoing, sweet-tempered, active, trainable");
        breedCharacteristicsMap.put("irish setter", irishSetterChars);
        breedCharacteristicsMap.put("setter", irishSetterChars); 

        Map<String, String> englishSetterChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "high", "temperament", "friendly, merry, gentle, active");
        breedCharacteristicsMap.put("english setter", englishSetterChars);

        Map<String, String> gordonSetterChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "high", "temperament", "bold, confident, affectionate, loyal");
        breedCharacteristicsMap.put("gordon setter", gordonSetterChars);

        Map<String, String> weimaranerChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "friendly, fearless, alert, obedient");
        breedCharacteristicsMap.put("weimaraner", weimaranerChars);

        Map<String, String> vizslaChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "affectionate, gentle, energetic, eager");
        breedCharacteristicsMap.put("vizsla", vizslaChars);

        Map<String, String> rhodesianRidgebackChars = Map.of("size", "large", "activityLevel", "moderate",
                "groomingNeeds", "low", "temperament", "dignified, even-tempered, affectionate, strong-willed");
        breedCharacteristicsMap.put("rhodesian ridgeback", rhodesianRidgebackChars);

        // --- 강아지 특징 (Newfoundlands, St. Bernards, Mastiffs, Schnauzers, Papillons,
        // Korean Breeds) ---
        Map<String, String> newfoundlandChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "sweet, patient, devoted, gentle giant");
        breedCharacteristicsMap.put("newfoundland", newfoundlandChars);

        Map<String, String> landseerChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "gentle, courageous, responsive, good swimmer"); 
        breedCharacteristicsMap.put("landseer", landseerChars);

        Map<String, String> stBernardChars = Map.of("size", "large", "activityLevel", "low", "groomingNeeds", "high",
                "temperament", "playful, charming, inquisitive, gentle giant");
        breedCharacteristicsMap.put("st. bernard", stBernardChars);

        Map<String, String> leonbergerChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "friendly, gentle, playful, calm");
        breedCharacteristicsMap.put("leonberger", leonbergerChars);

        Map<String, String> mastiffChars = Map.of("size", "large", "activityLevel", "low", "groomingNeeds", "low",
                "temperament", "courageous, dignified, good-natured, calm"); 
        breedCharacteristicsMap.put("mastiff", mastiffChars);

        Map<String, String> bullmastiffChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "low", "temperament", "affectionate, loyal, brave, protective");
        breedCharacteristicsMap.put("bullmastiff", bullmastiffChars);

        Map<String, String> neapolitanMastiffChars = Map.of("size", "large", "activityLevel", "low", "groomingNeeds",
                "moderate", "temperament", "watchful, dignified, loyal, steady");
        breedCharacteristicsMap.put("neapolitan mastiff", neapolitanMastiffChars);

        Map<String, String> tibetanMastiffChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "independent, reserved, protective, intelligent");
        breedCharacteristicsMap.put("tibetan mastiff", tibetanMastiffChars);

        Map<String, String> caneCorsoChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "affectionate, intelligent, majestic, assertive");
        breedCharacteristicsMap.put("cane corso", caneCorsoChars);

        Map<String, String> dogueDeBordeauxChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "low", "temperament", "loyal, affectionate, courageous, calm");
        breedCharacteristicsMap.put("dogue de bordeaux", dogueDeBordeauxChars);

        Map<String, String> schnauzerChars = Map.of("size", "variable", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "smart, fearless, spirited, alert"); // General
        breedCharacteristicsMap.put("schnauzer", schnauzerChars);
        breedCharacteristicsMap.put("miniature schnauzer", Map.of("size", "small", "activityLevel", "moderate",
                "groomingNeeds", "high", "temperament", "friendly, smart, obedient, alert"));
        breedCharacteristicsMap.put("standard schnauzer", Map.of("size", "medium", "activityLevel", "high",
                "groomingNeeds", "high", "temperament", "smart, fearless, spirited, reliable"));
        breedCharacteristicsMap.put("giant schnauzer", Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "high", "temperament", "loyal, alert, trainable, bold"));

        Map<String, String> papillonChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "friendly, alert, happy, intelligent");
        breedCharacteristicsMap.put("papillon", papillonChars);

        Map<String, String> phaleneChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "friendly, alert, happy, intelligent"); 
        breedCharacteristicsMap.put("phalene", phaleneChars);

        Map<String, String> jindoChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds", "moderate",
                "temperament", "loyal (to one owner), brave, alert, independent");
        breedCharacteristicsMap.put("jindo", jindoChars);

        Map<String, String> poongsanChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "moderate", "temperament", "loyal, brave, intelligent, agile");
        breedCharacteristicsMap.put("poongsan", poongsanChars);

        Map<String, String> sapsaliChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds", "high",
                "temperament", "friendly, playful, loyal, gentle");
        breedCharacteristicsMap.put("sapsali", sapsaliChars);

        // --- 강아지 일반 용어 특징 ---
        Map<String, String> dogChars = Map.of("size", "variable", "activityLevel", "variable", "groomingNeeds",
                "variable", "temperament", "loyal, companionable");
        breedCharacteristicsMap.put("dog", dogChars);
        breedCharacteristicsMap.put("puppy", dogChars);
        breedCharacteristicsMap.put("canine", dogChars);

        Map<String, String> gunDogChars = Map.of("size", "variable", "activityLevel", "high", "groomingNeeds",
                "variable", "temperament", "trainable, active, intelligent"); 
        breedCharacteristicsMap.put("gun dog", gunDogChars);

        Map<String, String> herdingDogChars = Map.of("size", "variable", "activityLevel", "high", "groomingNeeds",
                "variable", "temperament", "intelligent, energetic, trainable, loyal"); 
        breedCharacteristicsMap.put("herding dog", herdingDogChars);

        Map<String, String> sledDogChars = Map.of("size", "large", "activityLevel", "very_high", "groomingNeeds",
                "moderate", "temperament", "energetic, resilient, friendly, pack-oriented"); 
        breedCharacteristicsMap.put("sled dog", sledDogChars);

        Map<String, String> waterDogChars = Map.of("size", "variable", "activityLevel", "high", "groomingNeeds",
                "variable", "temperament", "intelligent, active, good swimmer"); 
        breedCharacteristicsMap.put("water dog", waterDogChars);

        Map<String, String> toyDogChars = Map.of("size", "small", "activityLevel", "variable", "groomingNeeds",
                "variable", "temperament", "companionable, affectionate, lively"); 
        breedCharacteristicsMap.put("toy dog", toyDogChars);

        Map<String, String> mixedBreedDogChars = Map.of("size", "variable", "activityLevel", "variable",
                "groomingNeeds", "variable", "temperament", "variable, unique"); 
        breedCharacteristicsMap.put("mixed breed", mixedBreedDogChars); 

        breedCharacteristicsMap.put("dog collar", Collections.emptyMap());
        breedCharacteristicsMap.put("dog supply", Collections.emptyMap());
        breedCharacteristicsMap.put("pet supply", Collections.emptyMap());
        breedCharacteristicsMap.put("collar", Collections.emptyMap());
        breedCharacteristicsMap.put("supply", Collections.emptyMap());
        breedCharacteristicsMap.put("pet", Collections.emptyMap()); 

        // --- 고양이 특징 ---
        Map<String, String> persianChars = Map.of("size", "medium", "activityLevel", "low", "groomingNeeds",
                "very_high", "temperament", "sweet, gentle, quiet, affectionate");
        breedCharacteristicsMap.put("persian", persianChars);

        Map<String, String> siameseChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "affectionate, social, vocal, intelligent");
        breedCharacteristicsMap.put("siamese", siameseChars);
        breedCharacteristicsMap.put("siamese cat", siameseChars);
        breedCharacteristicsMap.put("thai cat", siameseChars); 

        Map<String, String> ragdollChars = Map.of("size", "large", "activityLevel", "low", "groomingNeeds", "moderate",
                "temperament", "docile, gentle, affectionate, placid");
        breedCharacteristicsMap.put("ragdoll", ragdollChars);

        Map<String, String> bengalChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "active, curious, playful, intelligent");
        breedCharacteristicsMap.put("bengal", bengalChars);
        breedCharacteristicsMap.put("bengal cat", bengalChars);

        Map<String, String> britishShorthairChars = Map.of("size", "medium", "activityLevel", "low", "groomingNeeds",
                "low", "temperament", "easygoing, calm, affectionate, independent");
        breedCharacteristicsMap.put("british shorthair", britishShorthairChars);
        breedCharacteristicsMap.put("british longhair", Map.of("size", "medium", "activityLevel", "low",
                "groomingNeeds", "high", "temperament", "easygoing, calm, affectionate"));

        Map<String, String> scottishFoldChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "sweet, charming, undemanding, adaptable");
        breedCharacteristicsMap.put("scottish fold", scottishFoldChars);
        breedCharacteristicsMap.put("scottish straight", Map.of("size", "medium", "activityLevel", "moderate",
                "groomingNeeds", "low", "temperament", "sweet, charming, adaptable")); 

        Map<String, String> norwegianForestChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "gentle, friendly, independent, climber");
        breedCharacteristicsMap.put("norwegian forest cat", norwegianForestChars);

        Map<String, String> russianBlueChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "low", "temperament", "gentle, quiet, reserved, loyal");
        breedCharacteristicsMap.put("russian blue", russianBlueChars);
        breedCharacteristicsMap.put("russian white", russianBlueChars); 
        breedCharacteristicsMap.put("russian black", russianBlueChars); 

        Map<String, String> munchkinChars = Map.of("size", "small", "activityLevel", "moderate", "groomingNeeds",
                "variable", "temperament", "curious, playful, outgoing, short legs");
        breedCharacteristicsMap.put("munchkin", munchkinChars);
        breedCharacteristicsMap.put("munchkin cat", munchkinChars);

        Map<String, String> maineCoonChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "high", "temperament", "gentle giant, friendly, intelligent, playful");
        breedCharacteristicsMap.put("maine coon", maineCoonChars);

        Map<String, String> sphynxChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds", "high",
                "temperament", "affectionate, curious, energetic, hairless"); 
        breedCharacteristicsMap.put("sphynx", sphynxChars);
        breedCharacteristicsMap.put("peterbald", sphynxChars); 
        breedCharacteristicsMap.put("donskoy", sphynxChars); 

        Map<String, String> abyssinianChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "active, playful, curious, intelligent");
        breedCharacteristicsMap.put("abyssinian", abyssinianChars);

        Map<String, String> birmanChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "gentle, quiet, affectionate, pointed color");
        breedCharacteristicsMap.put("birman", birmanChars);

        Map<String, String> orientalShorthairChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds",
                "low", "temperament", "playful, curious, affectionate, vocal");
        breedCharacteristicsMap.put("oriental shorthair", orientalShorthairChars);
        breedCharacteristicsMap.put("oriental longhair", Map.of("size", "medium", "activityLevel", "high",
                "groomingNeeds", "moderate", "temperament", "playful, curious, affectionate, vocal"));

        Map<String, String> exoticShorthairChars = Map.of("size", "medium", "activityLevel", "low", "groomingNeeds",
                "moderate", "temperament", "sweet, gentle, quiet, affectionate"); // Shorthaired Persian
        breedCharacteristicsMap.put("exotic shorthair", exoticShorthairChars);

        Map<String, String> burmeseChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds", "low",
                "temperament", "affectionate, playful, social, people-oriented");
        breedCharacteristicsMap.put("burmese", burmeseChars);
        breedCharacteristicsMap.put("european burmese", burmeseChars);

        Map<String, String> americanShorthairChars = Map.of("size", "medium", "activityLevel", "moderate",
                "groomingNeeds", "low", "temperament", "easygoing, adaptable, friendly, good hunter");
        breedCharacteristicsMap.put("american shorthair", americanShorthairChars);

        Map<String, String> americanWirehairChars = Map.of("size", "medium", "activityLevel", "moderate",
                "groomingNeeds", "low", "temperament", "easygoing, adaptable, friendly, wiry coat");
        breedCharacteristicsMap.put("american wirehair", americanWirehairChars);

        Map<String, String> americanCurlChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "affectionate, curious, playful, curled ears");
        breedCharacteristicsMap.put("american curl", americanCurlChars);

        Map<String, String> japaneseBobtailChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds",
                "low", "temperament", "playful, smart, active, bobbed tail");
        breedCharacteristicsMap.put("japanese bobtail", japaneseBobtailChars);
        breedCharacteristicsMap.put("kurilian bobtail", Map.of("size", "medium", "activityLevel", "moderate",
                "groomingNeeds", "moderate", "temperament", "gentle, intelligent, playful, bobbed tail"));
        breedCharacteristicsMap.put("bobtail", japaneseBobtailChars); // 대표

        Map<String, String> devonRexChars = Map.of("size", "small", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "playful, mischievous, affectionate, wavy coat");
        breedCharacteristicsMap.put("devon rex", devonRexChars);
        breedCharacteristicsMap.put("cornish rex", Map.of("size", "small", "activityLevel", "high", "groomingNeeds",
                "low", "temperament", "active, affectionate, curious, wavy coat"));
        breedCharacteristicsMap.put("selkirk rex", Map.of("size", "medium", "activityLevel", "moderate",
                "groomingNeeds", "moderate", "temperament", "patient, tolerant, playful, curly coat"));
        breedCharacteristicsMap.put("german rex", devonRexChars); // Similar to Cornish/Devon

        Map<String, String> turkishAngoraChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds",
                "moderate", "temperament", "graceful, intelligent, playful, affectionate");
        breedCharacteristicsMap.put("turkish angora", turkishAngoraChars);

        Map<String, String> turkishVanChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds",
                "moderate", "temperament", "intelligent, energetic, loves water, distinctive pattern");
        breedCharacteristicsMap.put("turkish van", turkishVanChars);

        Map<String, String> manxChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds", "low",
                "temperament", "mellow, playful, intelligent, tailless/stub tail");
        breedCharacteristicsMap.put("manx", manxChars);
        breedCharacteristicsMap.put("cymric", Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "mellow, playful, intelligent, longhaired Manx"));

        Map<String, String> balineseChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds",
                "moderate", "temperament", "affectionate, social, vocal, intelligent"); 
        breedCharacteristicsMap.put("balinese", balineseChars);
        breedCharacteristicsMap.put("balinese cat", balineseChars);
        breedCharacteristicsMap.put("javanese", balineseChars); 

        Map<String, String> colorpointShorthairChars = Map.of("size", "medium", "activityLevel", "high",
                "groomingNeeds", "low", "temperament", "affectionate, social, vocal, intelligent");                                                                                    
        breedCharacteristicsMap.put("colorpoint shorthair", colorpointShorthairChars);

        Map<String, String> himalayanChars = Map.of("size", "medium", "activityLevel", "low", "groomingNeeds",
                "very_high", "temperament", "sweet, gentle, quiet, affectionate"); 
        breedCharacteristicsMap.put("himalayan", himalayanChars);

        Map<String, String> somaliChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds", "moderate",
                "temperament", "active, playful, curious, intelligent"); 
        breedCharacteristicsMap.put("somali", somaliChars);

        Map<String, String> ocicatChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "confident, active, social, spotted coat");
        breedCharacteristicsMap.put("ocicat", ocicatChars);

        Map<String, String> egyptianMauChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "gentle, agile, vocal, naturally spotted");
        breedCharacteristicsMap.put("egyptian mau", egyptianMauChars);

        Map<String, String> chartreuxChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "low", "temperament", "quiet, observant, gentle, smiling expression");
        breedCharacteristicsMap.put("chartreux", chartreuxChars);

        Map<String, String> koratChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds", "low",
                "temperament", "gentle, affectionate, intelligent, silver-blue coat");
        breedCharacteristicsMap.put("korat", koratChars);

        Map<String, String> singapuraChars = Map.of("size", "small", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "curious, playful, affectionate, smallest breed");
        breedCharacteristicsMap.put("singapura", singapuraChars);

        Map<String, String> tonkineseChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "affectionate, playful, social, curious"); 
        breedCharacteristicsMap.put("tonkinese", tonkineseChars);

        Map<String, String> bombayChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds", "low",
                "temperament", "affectionate, playful, curious, black coat");
        breedCharacteristicsMap.put("bombay", bombayChars);

        Map<String, String> havanaBrownChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "low", "temperament", "charming, playful, intelligent, brown coat");
        breedCharacteristicsMap.put("havana brown", havanaBrownChars);

        Map<String, String> snowshoeChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "low", "temperament", "affectionate, mellow, intelligent, white paws");
        breedCharacteristicsMap.put("snowshoe", snowshoeChars);

        Map<String, String> ragamuffinChars = Map.of("size", "large", "activityLevel", "low", "groomingNeeds",
                "moderate", "temperament", "docile, sweet, affectionate, similar to Ragdoll");
        breedCharacteristicsMap.put("ragamuffin", ragamuffinChars);

        Map<String, String> nebelungChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "gentle, quiet, reserved, longhaired Russian Blue");
        breedCharacteristicsMap.put("nebelung", nebelungChars);

        Map<String, String> lapermChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds",
                "moderate", "temperament", "affectionate, gentle, curious, curly coat");
        breedCharacteristicsMap.put("laperm", lapermChars);

        Map<String, String> pixieBobChars = Map.of("size", "large", "activityLevel", "moderate", "groomingNeeds",
                "variable", "temperament", "devoted, playful, intelligent, bobcat look");
        breedCharacteristicsMap.put("pixie-bob", pixieBobChars);

        Map<String, String> serengetiChars = Map.of("size", "medium", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "confident, alert, active, vocal");
        breedCharacteristicsMap.put("serengeti", serengetiChars);

        Map<String, String> toygerChars = Map.of("size", "medium", "activityLevel", "moderate", "groomingNeeds", "low",
                "temperament", "friendly, playful, intelligent, striped pattern");
        breedCharacteristicsMap.put("toyger", toygerChars);

        Map<String, String> chausieChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "active, intelligent, adventurous, wild look"); 
        breedCharacteristicsMap.put("chausie", chausieChars);

        Map<String, String> savannahChars = Map.of("size", "large", "activityLevel", "high", "groomingNeeds", "low",
                "temperament", "confident, curious, assertive, loyal"); 
        breedCharacteristicsMap.put("savannah", savannahChars);

        // --- 고양이 일반 용어 특징 ---
        Map<String, String> catChars = Map.of("size", "variable", "activityLevel", "variable", "groomingNeeds",
                "variable", "temperament", "independent, curious");
        breedCharacteristicsMap.put("cat", catChars);
        breedCharacteristicsMap.put("kitten", catChars);
        breedCharacteristicsMap.put("feline", catChars);

        Map<String, String> koreanShorthairChars = Map.of("size", "medium", "activityLevel", "moderate",
                "groomingNeeds", "low", "temperament", "variable, often friendly and adaptable");
        breedCharacteristicsMap.put("korean short-hair", koreanShorthairChars);
        breedCharacteristicsMap.put("domestic short-haired cat", koreanShorthairChars);
        breedCharacteristicsMap.put("domestic long-haired cat", Map.of("size", "medium", "activityLevel", "moderate",
                "groomingNeeds", "moderate", "temperament", "variable, often friendly and adaptable"));

        Map<String, String> mixedBreedCatChars = Map.of("size", "variable", "activityLevel", "variable",
                "groomingNeeds", "variable", "temperament", "variable, unique");
        breedCharacteristicsMap.put("moggy", mixedBreedCatChars);

        breedCharacteristicsMap.put("tabby", Collections.emptyMap());
        breedCharacteristicsMap.put("calico", Collections.emptyMap());
        breedCharacteristicsMap.put("tortoiseshell", Collections.emptyMap());
        breedCharacteristicsMap.put("tuxedo", Collections.emptyMap());
        breedCharacteristicsMap.put("white", Collections.emptyMap());
        breedCharacteristicsMap.put("black", Collections.emptyMap());

    }

    @Getter
    public static class BreedAnalysisResult {
        private String breedName;
        private float score;
        private Map<String, String> characteristics;

        public BreedAnalysisResult(String breedName, float score, Map<String, String> characteristics) {
            this.breedName = breedName;
            this.score = score;
            this.characteristics = characteristics != null ? characteristics : Collections.emptyMap();
        }

        public BreedAnalysisResult(String breedName, float score) {
            this(breedName, score, null);
        }

        public int getScorePercent() {
            return (int) (score * 100);
        }
    }

    public List<BreedAnalysisResult> analyzeImage(MultipartFile imageFile) throws IOException {
        List<BreedAnalysisResult> results = new ArrayList<>();
        log.info("Starting image analysis for file: {}", imageFile.getOriginalFilename());

        // 환경 변수 및 시스템 속성 로깅
        String envCredentialsPath = System.getenv("GOOGLE_APPLICATION_CREDENTIALS");
        String sysCredentialsPath = System.getProperty("GOOGLE_APPLICATION_CREDENTIALS");
        log.info("GOOGLE_APPLICATION_CREDENTIALS 환경 변수: {}", envCredentialsPath);
        log.info("GOOGLE_APPLICATION_CREDENTIALS 시스템 속성: {}", sysCredentialsPath);
        
        // 실제 사용할 자격 증명 파일 경로
        String credentialsPath = sysCredentialsPath != null && !sysCredentialsPath.isEmpty() 
                              ? sysCredentialsPath 
                              : "C:/petshop/credentials/gen-lang-client-0283444979-e37cfc993ab4.json";
        log.info("사용할 자격 증명 파일 경로: {}", credentialsPath);
        
        ImageAnnotatorClient vision = null;
        
        try {
            // 파일 존재 확인
            boolean credentialsFileExists = false;
            if (credentialsPath != null && !credentialsPath.isEmpty()) {
                credentialsFileExists = Files.exists(Paths.get(credentialsPath));
                log.info("자격 증명 파일 존재 여부: {}", credentialsFileExists);
            }
            
            // ImageAnnotatorClient 생성 시도
            if (credentialsFileExists) {
                log.info("명시적 자격 증명 파일로 ImageAnnotatorClient 생성 시도: {}", credentialsPath);
                try (FileInputStream credentialsStream = new FileInputStream(credentialsPath)) {
                    GoogleCredentials credentials = GoogleCredentials.fromStream(credentialsStream);
                    ImageAnnotatorSettings settings = ImageAnnotatorSettings.newBuilder()
                            .setCredentialsProvider(FixedCredentialsProvider.create(credentials))
                            .build();
                    vision = ImageAnnotatorClient.create(settings);
                    log.info("명시적 자격 증명으로 ImageAnnotatorClient 생성 성공");
                } catch (Exception e) {
                    log.error("명시적 자격 증명으로 클라이언트 생성 실패", e);
                    throw new IOException("Google Vision API 인증에 실패했습니다: " + e.getMessage(), e);
                }
            } else {
                log.error("자격 증명 파일을 찾을 수 없음: {}", credentialsPath);
                throw new IOException("Google Vision API 자격 증명 파일을 찾을 수 없습니다: " + credentialsPath);
            }

            ByteString imgBytes = ByteString.copyFrom(imageFile.getBytes());
            log.debug("Image converted to ByteString (size: {} bytes)", imgBytes.size());

            Image img = Image.newBuilder().setContent(imgBytes).build();

            Feature feat = Feature.newBuilder().setType(Feature.Type.LABEL_DETECTION).setMaxResults(10).build();
            AnnotateImageRequest request = AnnotateImageRequest.newBuilder().addFeatures(feat).setImage(img).build();
            log.info("Sending request to Google Vision API (Label Detection)");

            BatchAnnotateImagesResponse response = vision.batchAnnotateImages(List.of(request));
            List<AnnotateImageResponse> responses = response.getResponsesList();
            log.info("Received response from Google Vision API");

            for (AnnotateImageResponse res : responses) {
                if (res.hasError()) {
                    log.error("Google Vision API Error: {}", res.getError().getMessage());
                    throw new RuntimeException("Vision API Error: " + res.getError().getMessage());
                }

                log.debug("Processing {} label annotations.", res.getLabelAnnotationsCount());
                for (EntityAnnotation annotation : res.getLabelAnnotationsList()) {
                    String description = annotation.getDescription().toLowerCase();
                    float score = annotation.getScore();

                    if (isRelevantLabel(description) && score > 0.6) {
                        String translatedOrOriginal = translateToKorean(description);
                        String finalLabel = formatLabel(translatedOrOriginal);

                        Map<String, String> characteristics = breedCharacteristicsMap.get(description);

                        log.info("Relevant label detected: {} -> {} (Score: {})", annotation.getDescription(),
                                finalLabel, score);
                        results.add(new BreedAnalysisResult(finalLabel, score, characteristics));
                    } else {
                        log.debug("Ignoring label: {} (Score: {})", annotation.getDescription(), score);
                    }
                }
            }
        } catch (Exception e) {
            log.error("Error during Vision API call or processing", e);
            throw new IOException("Failed to analyze image using Vision API.", e);
        } finally {
            vision.close();
        }

        results.sort((r1, r2) -> Float.compare(r2.getScore(), r1.getScore()));
        log.info("Analysis finished. Found {} relevant results.", results.size());

        return results;
    }

    private String translateToKorean(String englishLabel) {
        return breedTranslationMap.getOrDefault(englishLabel.toLowerCase(), englishLabel);
    }

    private boolean isRelevantLabel(String description) {
        if (description.contains("dog") || description.contains("cat") || description.contains("puppy")
                || description.contains("kitten")) {
            return true;
        }
        String[] breedKeywords = {
                "retriever", "labrador", "golden", "flat-coated", "curly-coated", "chesapeake bay",
                "bulldog", "french", "english", "american bulldog", "olde english bulldogge", "australian bulldog",
                "terrier", "yorkshire", "jack russell", "bull terrier", "staffordshire", "pit bull", "scottish terrier",
                "west highland", "white terrier", "cairn", "airedale", "fox terrier", "wire fox", "smooth fox",
                "boston terrier", "small terrier",
                "poodle", "toy poodle", "miniature poodle", "standard poodle", "poodle crossbreed",
                "beagle", "beagle-harrier", "harrier",
                "dachshund", "shiba", "inu", "maltese", "pomeranian",
                "german shepherd", "shepherd", "belgian malinois", "malinois", "belgian tervuren", "tervuren",
                "old german shepherd", "king shepherd", 
                "siberian", "husky", "alaskan", "malamute", "klee kai", "northern inuit", 
                "welsh", "corgi", "pembroke", "cardigan",
                "boxer", "doberman", "pinscher", "rottweiler", "great dane", "bernese", "mountain", "swiss mountain",
                "australian", "cattle dog", "kelpie", "collie", "border", "rough collie", "smooth collie", "shetland",
                "sheepdog", "sheltie",
                "spaniel", "cocker", "springer", "english springer", "welsh springer", "brittany", "king charles",
                "cavalier",
                "chihuahua", "pug", "bichon", "frise", "havanese", "coton de tulear", "shih tzu", "lhasa apso",
                "tibetan terrier", "tibetan spaniel", "bolognese", 
                "akita", "japanese akita", "american akita", "samoyed", "eurasier", "keeshond",
                "greyhound", "whippet", "italian greyhound", "saluki", "afghan hound", "borzoi", "basenji", "foxhound",
                "american foxhound",
                "dalmatian", "pointer", "german shorthaired pointer", "german wirehaired pointer", "setter",
                "irish setter", "english setter", "gordon setter",
                "weimaraner", "vizsla", "rhodesian ridgeback", "ridgeback",
                "newfoundland", "landseer", "st. bernard", "leonberger",
                "mastiff", "bullmastiff", "neapolitan mastiff", "tibetan mastiff", "cane corso", "dogue de bordeaux",
                "schnauzer", "miniature schnauzer", "standard schnauzer", "giant schnauzer",
                "papillon", "phalene", "jindo", "korean jindo", "poongsan", "sapsali",
                "gun dog", "toy dog", "crossbreed", "herding", "sled", "water dog", 
                "collar", "supply", "pet supply", 

                // Cat Breeds
                "persian", "siamese", "thai", 
                "ragdoll", "bengal", "british", "shorthair", "longhair", "scottish", "fold", "straight",
                "norwegian", "forest", "russian", "blue", "white", "black", 
                "maine coon", "sphynx", "peterbald", "donskoy",
                "abyssinian", "birman", "sacred birman", "oriental", "oriental shorthair", "oriental longhair",
                "asian semi-longhair", 
                "exotic", "exotic shorthair", "burmese", "american", "european burmese",
                "american shorthair", "american wirehair", "american curl", "bobtail", "japanese bobtail",
                "kurilian bobtail",
                "devon rex", "cornish rex", "selkirk rex", "german rex",
                "turkish", "angora", "van", "manx", "cymric", "balinese", "javanese", "colorpoint shorthair",
                "himalayan", "somali", "ocicat", "egyptian mau", "chartreux", "korat", "singapura", "tonkinese",
                "bombay",
                "havana brown", "snowshoe", "ragamuffin", "nebelung", "laperm", "munchkin", "pixie-bob", "serengeti",
                "toyger", "chausie", "savannah",
                "tabby", "calico", "tortoiseshell", "tuxedo", "domestic", "mixed breed", "moggy"
        };
        for (String keyword : breedKeywords) {
            if (description.contains(keyword)) {
                return true;
            }
        }
        return false;
    }

    private String formatLabel(String originalLabel) {
        if (originalLabel == null || originalLabel.isEmpty()) {
            return "";
        }

        return originalLabel.substring(0, 1).toUpperCase() + originalLabel.substring(1);
    }
}
