package com.mc.app.service;

import com.google.cloud.vision.v1.*;
import com.google.protobuf.ByteString;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Slf4j
public class PetBreedAnalysisService {

    // 영어 -> 한국어 품종 번역 맵
    private static final Map<String, String> breedTranslationMap = new HashMap<>();

    static {
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
        breedTranslationMap.put("jack russell terrier", "잭 러셀 테리어"); // jack russell 추가
        breedTranslationMap.put("bull terrier", "불 테리어");
        breedTranslationMap.put("staffordshire bull terrier", "스태퍼드셔 불 테리어"); // staffordshire 추가
        breedTranslationMap.put("american staffordshire terrier", "아메리칸 스태퍼드셔 테리어");
        breedTranslationMap.put("pit bull terrier", "핏불 테리어"); // pit bull 추가
        breedTranslationMap.put("scottish terrier", "스코티시 테리어");
        breedTranslationMap.put("west highland white terrier", "웨스트 하일랜드 화이트 테리어"); // west highland, white terrier 추가
        breedTranslationMap.put("cairn terrier", "케언 테리어"); // cairn 추가
        breedTranslationMap.put("airedale terrier", "에어데일 테리어"); // airedale 추가
        breedTranslationMap.put("fox terrier", "폭스 테리어");
        breedTranslationMap.put("wire fox terrier", "와이어 폭스 테리어"); // wire fox 추가
        breedTranslationMap.put("smooth fox terrier", "스무스 폭스 테리어"); // smooth fox 추가
        breedTranslationMap.put("boston terrier", "보스턴 테리어");
        breedTranslationMap.put("small terrier", "소형 테리어");

        breedTranslationMap.put("poodle", "푸들");
        breedTranslationMap.put("toy poodle", "토이 푸들"); // toy 추가
        breedTranslationMap.put("miniature poodle", "미니어처 푸들"); // miniature 추가
        breedTranslationMap.put("standard poodle", "스탠더드 푸들"); // standard 추가

        breedTranslationMap.put("beagle", "비글");
        breedTranslationMap.put("beagle-harrier", "비글 해리어");
        breedTranslationMap.put("dachshund", "닥스훈트");
        breedTranslationMap.put("shiba inu", "시바견"); // shiba, inu 추가
        breedTranslationMap.put("maltese", "말티즈");
        breedTranslationMap.put("pomeranian", "포메라니안");

        breedTranslationMap.put("german shepherd", "저먼 셰퍼드"); // shepherd 추가
        breedTranslationMap.put("old german shepherd dog", "올드 저먼 셰퍼드 도그"); // Old german shepherd dog 추가
        breedTranslationMap.put("king shepherd", "킹 셰퍼드"); // King shepherd 추가
        breedTranslationMap.put("belgian malinois", "벨지안 말리노이즈"); // malinois 추가
        breedTranslationMap.put("belgian tervuren", "벨지안 테뷰런"); // tervuren 추가

        breedTranslationMap.put("siberian husky", "시베리안 허스키"); // siberian, husky 추가
        breedTranslationMap.put("alaskan malamute", "알래스칸 맬러뮤트"); // alaskan, malamute 추가
        breedTranslationMap.put("alaskan klee kai", "알래스칸 클리카이"); // klee kai 추가

        breedTranslationMap.put("welsh corgi", "웰시 코기"); // welsh, corgi 추가
        breedTranslationMap.put("pembroke welsh corgi", "펨브록 웰시 코기"); // pembroke 추가
        breedTranslationMap.put("cardigan welsh corgi", "카디건 웰시 코기"); // cardigan 추가

        breedTranslationMap.put("boxer", "복서");
        breedTranslationMap.put("doberman pinscher", "도베르만 핀셔"); // doberman, pinscher 추가
        breedTranslationMap.put("rottweiler", "로트와일러");
        breedTranslationMap.put("great dane", "그레이트 데인");
        breedTranslationMap.put("bernese mountain dog", "버니즈 마운틴 도그"); // bernese, mountain 추가
        breedTranslationMap.put("northern inuit dog", "노던 이누이트 도그");
        breedTranslationMap.put("greater swiss mountain dog", "그레이터 스위스 마운틴 도그"); // swiss mountain 추가

        breedTranslationMap.put("australian shepherd", "오스트레일리안 셰퍼드"); // australian 추가
        breedTranslationMap.put("australian cattle dog", "오스트레일리안 캐틀 도그"); // cattle dog 추가
        breedTranslationMap.put("australian kelpie", "오스트레일리안 켈피"); // kelpie 추가

        breedTranslationMap.put("collie", "콜리");
        breedTranslationMap.put("border collie", "보더 콜리"); // border 추가
        breedTranslationMap.put("rough collie", "러프 콜리"); // rough collie 추가
        breedTranslationMap.put("smooth collie", "스무스 콜리"); // smooth collie 추가
        breedTranslationMap.put("shetland sheepdog", "셔틀랜드 쉽독"); // shetland, sheepdog, sheltie 추가

        breedTranslationMap.put("spaniel", "스패니얼");
        breedTranslationMap.put("cocker spaniel", "코커 스패니얼"); // cocker 추가
        breedTranslationMap.put("english springer spaniel", "잉글리시 스프링어 스패니얼"); // springer, english springer 추가
        breedTranslationMap.put("welsh springer spaniel", "웰시 스프링어 스패니얼"); // welsh springer 추가
        breedTranslationMap.put("brittany spaniel", "브리트니 스패니얼"); // brittany 추가
        breedTranslationMap.put("king charles spaniel", "킹 찰스 스패니얼"); // king charles 추가
        breedTranslationMap.put("cavalier king charles spaniel", "카발리에 킹 찰스 스패니얼"); // cavalier 추가

        breedTranslationMap.put("chihuahua", "치와와");
        breedTranslationMap.put("pug", "퍼그");
        breedTranslationMap.put("bichon frise", "비숑 프리제"); // bichon, frise 추가
        breedTranslationMap.put("bichon", "비숑"); // Bichon 키워드 추가 (기존 frise와 별개로)
        breedTranslationMap.put("bolognese dog", "볼로네즈 도그"); // Bolognese dog 추가
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
        breedTranslationMap.put("rhodesian ridgeback", "로디지안 리지백"); // ridgeback 추가

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

        breedTranslationMap.put("jindo", "진돗개"); // korean jindo 추가
        breedTranslationMap.put("poongsan", "풍산개");
        breedTranslationMap.put("sapsali", "삽살개");

        // 일반 강아지 관련 용어
        breedTranslationMap.put("dog", "강아지");
        breedTranslationMap.put("puppy", "강아지");
        breedTranslationMap.put("canine", "개과 동물");
        breedTranslationMap.put("gun dog", "조렵견");
        breedTranslationMap.put("herding dog", "목축견"); // Herding dog 추가
        breedTranslationMap.put("sled dog", "썰매견"); // Sled dog 추가
        breedTranslationMap.put("water dog", "워터 도그"); // Water dog 추가
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
        breedTranslationMap.put("british shorthair", "브리티시 쇼트헤어"); // british, shorthair 추가
        breedTranslationMap.put("british longhair", "브리티시 롱헤어"); // longhair 추가
        breedTranslationMap.put("scottish fold", "스코티시 폴드"); // scottish, fold 추가
        breedTranslationMap.put("scottish straight", "스코티시 스트레이트"); // straight 추가
        breedTranslationMap.put("norwegian forest cat", "노르웨이 숲 고양이"); // norwegian, forest 추가
        breedTranslationMap.put("russian blue", "러시안 블루"); // russian, blue 추가
        breedTranslationMap.put("russian white", "러시안 화이트"); // white 추가
        breedTranslationMap.put("russian black", "러시안 블랙"); // black 추가
        breedTranslationMap.put("bengal cat", "벵갈 고양이"); // Bengal cat 추가 (기존 bengal과 별개)
        breedTranslationMap.put("siamese cat", "샴 고양이"); // Siamese cat 추가 (기존 siamese와 별개)
        breedTranslationMap.put("thai cat", "타이 고양이"); // Thai cat 추가
        breedTranslationMap.put("balinese cat", "발리니즈 고양이"); // Balinese cat 추가 (기존 balinese와 별개)
        breedTranslationMap.put("asian semi-longhair", "아시안 세미 롱헤어"); // Asian semi-longhair 추가
        breedTranslationMap.put("munchkin cat", "먼치킨 고양이");

        breedTranslationMap.put("maine coon", "메인쿤");
        breedTranslationMap.put("sphynx", "스핑크스");
        breedTranslationMap.put("peterbald", "피터볼드");
        breedTranslationMap.put("donskoy", "돈스코이");

        breedTranslationMap.put("abyssinian", "아비시니안");
        breedTranslationMap.put("birman", "버만"); // sacred birman 추가
        breedTranslationMap.put("oriental shorthair", "오리엔탈 쇼트헤어"); // oriental 추가
        breedTranslationMap.put("oriental longhair", "오리엔탈 롱헤어");
        breedTranslationMap.put("exotic shorthair", "엑조틱 쇼트헤어"); // exotic 추가
        breedTranslationMap.put("burmese", "버미즈");
        breedTranslationMap.put("european burmese", "유러피안 버미즈");

        breedTranslationMap.put("american shorthair", "아메리칸 쇼트헤어"); // american 추가
        breedTranslationMap.put("american wirehair", "아메리칸 와이어헤어"); // wirehair 추가
        breedTranslationMap.put("american curl", "아메리칸 컬"); // curl 추가
        breedTranslationMap.put("japanese bobtail", "재패니즈 밥테일"); // bobtail 추가
        breedTranslationMap.put("kurilian bobtail", "쿠릴리안 밥테일");

        breedTranslationMap.put("devon rex", "데본 렉스"); // rex 추가
        breedTranslationMap.put("cornish rex", "코니시 렉스");
        breedTranslationMap.put("selkirk rex", "셀커크 렉스");
        breedTranslationMap.put("german rex", "저먼 렉스");

        breedTranslationMap.put("turkish angora", "터키시 앙고라"); // turkish, angora 추가
        breedTranslationMap.put("turkish van", "터키시 반"); // van 추가
        breedTranslationMap.put("manx", "맹크스");
        breedTranslationMap.put("cymric", "킴릭");
        breedTranslationMap.put("balinese", "발리니즈");
        breedTranslationMap.put("javanese", "자바니즈");
        breedTranslationMap.put("colorpoint shorthair", "컬러포인트 쇼트헤어"); // colorpoint 추가
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
        breedTranslationMap.put("korean short-hair", "코리안 쇼트헤어"); // 한국 고양이
        breedTranslationMap.put("cat", "고양이");
        breedTranslationMap.put("kitten", "아기 고양이");
        breedTranslationMap.put("feline", "고양이과 동물");
        breedTranslationMap.put("tabby", "태비 (줄무늬 고양이)");
        breedTranslationMap.put("calico", "칼리코 (삼색 고양이)");
        breedTranslationMap.put("tortoiseshell", "톨토이즈쉘 (카오스 고양이)");
        breedTranslationMap.put("tuxedo", "턱시도 고양이");
        breedTranslationMap.put("domestic short-haired cat", "도메스틱 쇼트헤어 (집고양이)"); // domestic 추가
        breedTranslationMap.put("domestic long-haired cat", "도메스틱 롱헤어 (집고양이)");
        breedTranslationMap.put("mixed breed", "믹스견/믹스묘");
        breedTranslationMap.put("moggy", "믹스묘 (영국식)");
        breedTranslationMap.put("pet", "반려동물");
        breedTranslationMap.put("mixed breed", "믹스견/믹스묘");
        breedTranslationMap.put("white", "흰색 고양이");

    }

    public List<BreedAnalysisResult> analyzeImage(MultipartFile imageFile) throws IOException {
        List<BreedAnalysisResult> results = new ArrayList<>();
        log.info("Starting image analysis for file: {}", imageFile.getOriginalFilename());

        try (ImageAnnotatorClient vision = ImageAnnotatorClient.create()) {
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

                        log.info("Relevant label detected: {} -> {} (Score: {})", annotation.getDescription(),
                                finalLabel, score);
                        results.add(new BreedAnalysisResult(finalLabel, score));
                    } else {
                        log.debug("Ignoring label: {} (Score: {})", annotation.getDescription(), score);
                    }
                }
            }
        } catch (Exception e) {
            log.error("Error during Vision API call or processing", e);
            throw new IOException("Failed to analyze image using Vision API.", e);
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
                // 강아지 (Dog Breeds) - 추가 확장
                "retriever", "labrador", "golden", "flat-coated", "curly-coated", "chesapeake bay",
                "bulldog", "french", "english", "american bulldog", "olde english bulldogge", "australian bulldog",
                "terrier", "yorkshire", "jack russell", "bull terrier", "staffordshire", "pit bull", "scottish terrier",
                "west highland", "white terrier", "cairn", "airedale", "fox terrier", "wire fox", "smooth fox",
                "boston terrier", "small terrier",
                "poodle", "toy poodle", "miniature poodle", "standard poodle", "poodle crossbreed",
                "beagle", "beagle-harrier", "harrier",
                "dachshund", "shiba", "inu", "maltese", "pomeranian",
                "german shepherd", "shepherd", "belgian malinois", "malinois", "belgian tervuren", "tervuren",
                "old german shepherd", "king shepherd", // old german shepherd, king shepherd 추가
                "siberian", "husky", "alaskan", "malamute", "klee kai", "northern inuit", // northern inuit 추가
                "welsh", "corgi", "pembroke", "cardigan",
                "boxer", "doberman", "pinscher", "rottweiler", "great dane", "bernese", "mountain", "swiss mountain",
                "australian", "cattle dog", "kelpie", "collie", "border", "rough collie", "smooth collie", "shetland",
                "sheepdog", "sheltie",
                "spaniel", "cocker", "springer", "english springer", "welsh springer", "brittany", "king charles",
                "cavalier",
                "chihuahua", "pug", "bichon", "frise", "havanese", "coton de tulear", "shih tzu", "lhasa apso",
                "tibetan terrier", "tibetan spaniel", "bolognese", // bolognese 추가
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
                "gun dog", "toy dog", "crossbreed", "herding", "sled", "water dog", // herding, sled, water dog 추가
                "collar", "supply", "pet supply", // pet supply 추가

                // 고양이 (Cat Breeds) - 추가 확장
                "persian", "siamese", "thai", // thai 추가
                "ragdoll", "bengal", "british", "shorthair", "longhair", "scottish", "fold", "straight",
                "norwegian", "forest", "russian", "blue", "white", "black", // white 추가 (색상)
                "maine coon", "sphynx", "peterbald", "donskoy",
                "abyssinian", "birman", "sacred birman", "oriental", "oriental shorthair", "oriental longhair",
                "asian semi-longhair", // asian semi-longhair 추가
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

    public static class BreedAnalysisResult {
        private String breedName;
        private float score;

        public BreedAnalysisResult(String breedName, float score) {
            this.breedName = breedName;
            this.score = score;
        }

        public String getBreedName() {
            return breedName;
        }

        public float getScore() {
            return score;
        }

        public int getScorePercent() {
            return (int) (score * 100);
        }
    }
}
