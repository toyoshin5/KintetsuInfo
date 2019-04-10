//
//  MapViewController.swift
//  KintetsuInfo
//
//  Created by Toyoshin on 2018/10/12.
//  Copyright © 2018 Toyoshin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Ji
import KRProgressHUD

//class Load{
//    let loadView = UIView()
//    let loadindicator = UIActivityIndicatorView()
//    let textLabel = UILabel()
//    let screenX = CGFloat()
//    let screenY = CGFloat()
//    let offset = CGFloat()
//    init() {
//        offset = 200
//        screenX = UIScreen.main.bounds.width
//        screenY = UIScreen.main.bounds.height
//        loadView.frame = CGRect(x: 0, y: screenY-offset, width: screenX, height: offset)
//        
//        
//        
//        textLabel.frame =
//    }
//}
class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{
    
    
    let stationList = [
        (title:"津",latitude:34.7340775 ,longitude:136.5105046),
        (title:"白子",latitude:34.8338642,longitude:136.5895010)
        ,
        (title:"青山町",latitude:34.672847,longitude:136.177764),
        (title:"赤目口",latitude:34.599833,longitude:136.074600),
        (title:"阿倉川",latitude:34.984694,longitude:136.628733),
        (title:"明野",latitude:34.521319,longitude:136.668806),
        (title:"朝熊",latitude:34.477339,longitude:136.758628),
        (title:"飛鳥",latitude:34.464772,longitude:135.798183),
        (title:"尼ヶ辻",latitude:34.681483,longitude:135.783625),
        (title:"菖蒲池",latitude:34.698103,longitude:135.760922),
        (title:"荒本",latitude:34.678628,longitude:135.604914),
        (title:"安堂",latitude:34.580025,longitude:135.629089),
        (title:"伊勢朝日",latitude:35.038153,longitude:136.668978),
        (title:"大阪阿部野橋",latitude:34.645636,longitude:135.513906),
        (title:"河内天美",latitude:34.586347,longitude:135.535217),
        (title:"志摩赤崎",latitude:34.469908,longitude:136.841967),
        (title:"大和朝倉",latitude:34.516108,longitude:135.869106),
        (title:"伊賀神戸",latitude:34.673842,longitude:136.152911),
        (title:"伊賀上津",latitude:34.682694,longitude:136.205086),
        (title:"池の浦",latitude:34.479489,longitude:136.818775),
        (title:"池部",latitude:34.578647,longitude:135.737553),
        (title:"生駒山上",latitude:34.679569,longitude:135.680650),
        (title:"石切",latitude:34.685311,longitude:135.655575),
        (title:"五十鈴川",latitude:34.476703,longitude:136.727258),
        (title:"伊勢朝日",latitude:35.038153,longitude:136.668978),
        (title:"伊勢石橋",latitude:34.656783,longitude:136.408033),
        (title:"伊勢川島",latitude:34.977664,longitude:136.566697),
        (title:"伊勢市",latitude:34.491111,longitude:136.709500),
        (title:"伊勢田",latitude:34.881750,longitude:135.778758),
        (title:"伊勢中川",latitude:34.635022,longitude:136.477886),
        (title:"伊勢中原",latitude:34.614800,longitude:136.497531),
        (title:"伊勢松本",latitude:34.969733,longitude:136.590586),
        (title:"伊勢若松",latitude:34.869139,longitude:136.616306),
        (title:"磯山",latitude:34.812428,longitude:136.568536),
        (title:"市尾",latitude:34.441761,longitude:135.776125),
        (title:"一分",latitude:34.675322,longitude:135.708022),
        (title:"磐城",latitude:34.511383,longitude:135.710892),
        (title:"石見",latitude:34.571867,longitude:135.785889),
        (title:"志摩磯部",latitude:34.369914,longitude:136.805408),
        (title:"鵜方",latitude:34.329367,longitude:136.825919),
        (title:"浮孔",latitude:34.498250,longitude:135.754139),
        (title:"宇治山田",latitude:34.488200,longitude:136.713739),
        (title:"畝傍御陵前",latitude:34.493442,longitude:135.794139),
        (title:"大阪上本町",latitude:34.665550,longitude:135.521250),
        (title:"恵我ノ荘",latitude:34.573453,longitude:135.573203),
        (title:"江戸橋",latitude:34.743611,longitude:136.514056),
        (title:"河内永和",latitude:34.664372,longitude:135.572919),
        (title:"王寺",latitude:34.597431,longitude:135.703956),
        (title:"大阿太",latitude:34.388194,longitude:135.766361),
        (title:"大阪阿部野橋",latitude:34.645636,longitude:135.513906),
        (title:"大阪上本町",latitude:34.665550,longitude:135.521250),
        (title:"大阪教育大前",latitude:34.555322,longitude:135.645314),
        (title:"大阪難波",latitude:34.667114,longitude:135.499142),
        (title:"大羽根園",latitude:35.012617,longitude:136.494161),
        (title:"大三",latitude:34.664067,longitude:136.368400),
        (title:"大輪田",latitude:34.589158,longitude:135.720325),
        (title:"岡寺",latitude:34.474256,longitude:135.796089),
        (title:"忍海",latitude:34.476333,longitude:135.732011),
        (title:"恩智",latitude:34.609783,longitude:135.626147),
        (title:"伊賀神戸",latitude:34.673842,longitude:136.152911),
        (title:"伊勢川島",latitude:34.977664,longitude:136.566697),
        (title:"笠縫",latitude:34.541786,longitude:135.793992),
        (title:"賢島",latitude:34.308492,longitude:136.818586),
        (title:"橿原神宮西口",latitude:34.486128,longitude:135.781822),
        (title:"橿原神宮前",latitude:34.484381,longitude:135.794478),
        (title:"柏原南口",latitude:34.581283,longitude:135.624944),
        (title:"霞ヶ浦",latitude:34.992825,longitude:136.636578),
        (title:"烏森",latitude:35.152972,longitude:136.863986),
        (title:"堅下",latitude:34.588603,longitude:135.627364),
        (title:"上鳥羽口",latitude:34.965375,longitude:135.752456),
        (title:"上之郷",latitude:34.379572,longitude:136.811442),
        (title:"上ノ太子",latitude:34.533006,longitude:135.637981),
        (title:"川合高岡",latitude:34.656458,longitude:136.436292),
        (title:"川越富洲原",latitude:35.016553,longitude:136.660461),
        (title:"河内天美",latitude:34.586347,longitude:135.535217),
        (title:"河内永和",latitude:34.664372,longitude:135.572919),
        (title:"河内国分",latitude:34.566917,longitude:135.635619),
        (title:"河内小阪",latitude:34.664092,longitude:135.581306),
        (title:"河内長野",latitude:34.451108,longitude:135.573097),
        (title:"河内花園",latitude:34.662686,longitude:135.618333),
        (title:"河内松原",latitude:34.575522,longitude:135.557131),
        (title:"河内山本",latitude:34.627956,longitude:135.619622),
        (title:"川原町",latitude:34.976672,longitude:136.622864),
        (title:"学研北生駒",latitude:34.724914,longitude:135.723456),
        (title:"学研奈良登美ヶ丘",latitude:34.726544,longitude:135.752436),
        (title:"近鉄蟹江",latitude:35.129742,longitude:136.794161),
        (title:"大和上市",latitude:34.395558,longitude:135.845608),
        (title:"桔梗が丘",latitude:34.641344,longitude:136.112647),
        (title:"喜志",latitude:34.522833,longitude:135.607194),
        (title:"北楠",latitude:34.916053,longitude:136.625028),
        (title:"北田辺",latitude:34.632383,longitude:135.528872),
        (title:"木津川台",latitude:34.746608,longitude:135.796050),
        (title:"久宝寺口",latitude:34.634797,longitude:135.590342),
        (title:"京都",latitude:34.985458,longitude:135.757756),
        (title:"近鉄郡山",latitude:34.646617,longitude:135.781028),
        (title:"近鉄御所",latitude:34.464400,longitude:135.732542),
        (title:"近鉄下田",latitude:34.541425,longitude:135.704022),
        (title:"近鉄新庄",latitude:34.488783,longitude:135.727478),
        (title:"近鉄丹波橋",latitude:34.938425,longitude:135.766356),
        (title:"近鉄富田",latitude:35.006814,longitude:136.649706),
        (title:"近鉄長島",latitude:35.097806,longitude:136.696708),
        (title:"近鉄名古屋",latitude:35.169139,longitude:136.884306),
        (title:"近鉄奈良",latitude:34.684436,longitude:135.827419),
        (title:"近鉄日本橋",latitude:34.666950,longitude:135.505817),
        (title:"近鉄八田",latitude:35.149542,longitude:136.854306),
        (title:"近鉄宮津",latitude:34.791453,longitude:135.787458),
        (title:"近鉄八尾",latitude:34.629703,longitude:135.603872),
        (title:"近鉄弥富",latitude:35.113611,longitude:136.727639),
        (title:"近鉄四日市",latitude:34.967000,longitude:136.618681),
        (title:"櫛田",latitude:34.548886,longitude:136.582708),
        (title:"楠",latitude:34.904392,longitude:136.631139),
        (title:"薬水",latitude:34.407506,longitude:135.743086),
        (title:"葛",latitude:34.431481,longitude:135.759922),
        (title:"沓掛",latitude:34.394367,longitude:136.814253),
        (title:"久津川",latitude:34.864736,longitude:135.774814),
        (title:"桑名",latitude:35.067389,longitude:136.684111),
        (title:"伊賀上津",latitude:34.682694,longitude:136.205086),
        (title:"漕代",latitude:34.540744,longitude:136.601375),
        (title:"興戸",latitude:34.808197,longitude:135.778725),
        (title:"越部",latitude:34.386072,longitude:135.802692),
        (title:"河堀口",latitude:34.641350,longitude:135.523947),
        (title:"駒ヶ谷",latitude:34.545525,longitude:135.622483),
        (title:"狛田",latitude:34.780658,longitude:135.789378),
        (title:"米野",latitude:35.161625,longitude:136.880014),
        (title:"菰野",latitude:35.008750,longitude:136.517583),
        (title:"五位堂",latitude:34.534772,longitude:135.718144),
        (title:"五知",latitude:34.406944,longitude:136.810228),
        (title:"斎宮",latitude:34.537686,longitude:136.615447),
        (title:"榊原温泉口",latitude:34.674805,longitude:136.348813),
        (title:"佐古木",latitude:35.119514,longitude:136.752181),
        (title:"佐味田川",latitude:34.585214,longitude:135.731181),
        (title:"大和西大寺",latitude:34.693783,longitude:135.782733),
        (title:"近鉄下田",latitude:34.541425,longitude:135.704022),
        (title:"近鉄新庄",latitude:34.488783,longitude:135.727478),
        (title:"汐ノ宮",latitude:34.467083,longitude:135.579278),
        (title:"塩浜",latitude:34.932383,longitude:136.622175),
        (title:"信貴山口",latitude:34.620264,longitude:135.642078),
        (title:"信貴山下",latitude:34.601028,longitude:135.695031),
        (title:"志摩赤崎",latitude:34.469908,longitude:136.841967),
        (title:"志摩磯部",latitude:34.369914,longitude:136.805408),
        (title:"志摩神明",latitude:34.316203,longitude:136.829975),
        (title:"志摩横山",latitude:34.334233,longitude:136.817981),
        (title:"下市口",latitude:34.383747,longitude:135.787342),
        (title:"尺土",latitude:34.508567,longitude:135.721064),
        (title:"俊徳道",latitude:34.658303,longitude:135.571836),
        (title:"白木",latitude:34.429053,longitude:136.830500),
        (title:"白塚",latitude:34.770361,longitude:136.532472),
        (title:"白庭台",latitude:34.721078,longitude:135.716911),
        (title:"白子",latitude:34.834025,longitude:136.589583),
        (title:"新石切",latitude:34.680186,longitude:135.640886),
        (title:"新王寺",latitude:34.597431,longitude:135.703956),
        (title:"新大宮",latitude:34.685453,longitude:135.811508),
        (title:"新正",latitude:34.955539,longitude:136.618653),
        (title:"新田辺",latitude:34.820856,longitude:135.772872),
        (title:"新祝園",latitude:34.759914,longitude:135.792689),
        (title:"鈴鹿市",latitude:34.8838884,longitude:136.5827718),
        (title:"勢野北口",latitude:34.606047,longitude:135.700833),
        (title:"前栽",latitude:34.601003,longitude:135.816550),
        (title:"近鉄丹波橋",latitude:34.938425,longitude:135.766356),
        (title:"当麻寺",latitude:34.516003,longitude:135.706078),
        (title:"高田市",latitude:34.506811,longitude:135.742672),
        (title:"高田本山",latitude:34.755556,longitude:136.516417),
        (title:"高角",latitude:34.983678,longitude:136.554108),
        (title:"高の原",latitude:34.723747,longitude:135.791847),
        (title:"高見ノ里",latitude:34.575139,longitude:135.546761),
        (title:"高安",latitude:34.618997,longitude:135.624586),
        (title:"高安山",latitude:34.613814,longitude:135.653803),
        (title:"高鷲",latitude:34.571553,longitude:135.584069),
        (title:"滝谷不動",latitude:34.481000,longitude:135.586389),
        (title:"但馬",latitude:34.569358,longitude:135.767875),
        (title:"竜田川",latitude:34.617592,longitude:135.704611),
        (title:"田原本",latitude:34.553564,longitude:135.790789),
        (title:"大福",latitude:34.512950,longitude:135.829628),
        (title:"大和高田",latitude:34.519867,longitude:135.742358),
        (title:"千代崎",latitude:34.854353,longitude:136.607919),
        (title:"築山",latitude:34.525925,longitude:135.733369),
        (title:"津新町",latitude:34.715972,longitude:136.499825),
        (title:"鼓ヶ浦",latitude:34.826014,longitude:136.581211),
        (title:"壺阪山",latitude:34.449794,longitude:135.794933),
          (title:"鶴橋",latitude:34.665347,longitude:135.531297),
        (title:"天理",latitude:34.600692,longitude:135.830478),
        (title:"近鉄富田",latitude:35.006814,longitude:136.649706),
        (title:"東寺",latitude:34.979886,longitude:135.752633),
        (title:"富野荘",latitude:34.839872,longitude:135.772906),
        (title:"鳥羽",latitude:34.486475,longitude:136.842786),
        (title:"富雄",latitude:34.694311,longitude:135.735122),
        (title:"富吉",latitude:35.123389,longitude:136.768583),
        (title:"豊津上野",latitude:34.785522,longitude:136.543717),
        (title:"鳥居前",latitude:34.692367,longitude:135.696150),
        (title:"富田林",latitude:34.504556,longitude:135.601278),
        (title:"富田林西口",latitude:34.500778,longitude:135.596556),
        (title:"道明寺",latitude:34.567917,longitude:135.620083),
        (title:"伊勢中川",latitude:34.635022,longitude:136.477886),
        (title:"伊勢中原",latitude:34.614800,longitude:136.497531),
        (title:"大阪難波",latitude:34.667114,longitude:135.499142),
        (title:"河内長野",latitude:34.451108,longitude:135.573097),
        (title:"学研奈良登美ヶ丘",latitude:34.726544,longitude:135.752436),
        (title:"近鉄長島",latitude:35.097806,longitude:136.696708),
        (title:"近鉄名古屋",latitude:35.169139,longitude:136.884306),
        (title:"近鉄奈良",latitude:34.684436,longitude:135.827419),
        (title:"中川原",latitude:34.969111,longitude:136.602444),
        (title:"中菰野",latitude:35.012150,longitude:136.504592),
        (title:"中之郷",latitude:34.479450,longitude:136.845517),
        (title:"長瀬",latitude:34.650294,longitude:135.577436),
        (title:"長太ノ浦",latitude:34.891931,longitude:136.626414),
        (title:"菜畑",latitude:34.685758,longitude:135.706758),
        (title:"名張",latitude:34.621686,longitude:136.095928),
        (title:"近鉄日本橋",latitude:34.666950,longitude:135.505817),
        (title:"二階堂",latitude:34.602103,longitude:135.795508),
        (title:"西青山",latitude:34.676522,longitude:136.237986),
        (title:"西田原本",latitude:34.553564,longitude:135.790789),
        (title:"西ノ京",latitude:34.670264,longitude:135.783253),
        (title:"二上",latitude:34.546361,longitude:135.688331),
        (title:"二上山",latitude:34.539086,longitude:135.685969),
        (title:"二上神社口",latitude:34.532025,longitude:135.694275),
        (title:"新ノ口",latitude:34.525217,longitude:135.794828),
        (title:"布忍",latitude:34.577525,longitude:135.539494),
        (title:"河内花園",latitude:34.662686,longitude:135.618333),
        (title:"近鉄八田",latitude:35.149542,longitude:136.854306),
        (title:"榛原",latitude:34.529875,longitude:135.954717),
        (title:"萩の台",latitude:34.656650,longitude:135.708994),
        (title:"箸尾",latitude:34.570144,longitude:135.751447),
        (title:"土師ノ里",latitude:34.571742,longitude:135.615397),
        (title:"長谷寺",latitude:34.527031,longitude:135.906258),
        (title:"服部川",latitude:34.626250,longitude:135.641500),
        (title:"針中野",latitude:34.617111,longitude:135.532972),
        (title:"東青山",latitude:34.675900,longitude:136.321519),
        (title:"東生駒",latitude:34.691650,longitude:135.709797),
        (title:"東花園",latitude:34.662586,longitude:135.626525),
        (title:"東松阪",latitude:34.565150,longitude:136.546236),
        (title:"久居",latitude:34.675794,longitude:136.477819),
        (title:"枚岡",latitude:34.669900,longitude:135.648117),
        (title:"平田町",latitude:34.874800,longitude:136.542003),
        (title:"平端",latitude:34.606583,longitude:135.782589),
        (title:"ファミリー公園前",latitude:34.598033,longitude:135.784872),
        (title:"福神",latitude:34.395361,longitude:135.750186),
        (title:"伏屋",latitude:35.140167,longitude:136.827500),
        (title:"藤井寺",latitude:34.571533,longitude:135.594442),
        (title:"布施",latitude:34.664117,longitude:135.563211),
        (title:"平城",latitude:34.701583,longitude:135.785039),
        (title:"平群",latitude:34.629267,longitude:135.704311),
        (title:"宝山寺",latitude:34.686083,longitude:135.689139),
        (title:"法善寺",latitude:34.594783,longitude:135.626286),
        (title:"坊城",latitude:34.493319,longitude:135.765556),
        (title:"伊勢松本",latitude:34.969733,longitude:136.590586),
        (title:"河内松原",latitude:34.575522,longitude:135.557131),
        (title:"益生",latitude:35.058944,longitude:136.678944),
        (title:"真菅",latitude:34.519517,longitude:135.772639),
        (title:"松阪",latitude:34.576889,longitude:136.535528),
        (title:"松塚",latitude:34.520719,longitude:135.761919),
        (title:"近鉄宮津",latitude:34.791453,longitude:135.787458),
        (title:"箕田",latitude:34.879978,longitude:136.622133),
        (title:"三日市",latitude:34.880219,longitude:136.562158),
        (title:"弥刀",latitude:34.640836,longitude:135.583983),
        (title:"南生駒",latitude:34.665528,longitude:135.708806),
        (title:"南が丘",latitude:34.692464,longitude:136.496947),
        (title:"美旗",latitude:34.663275,longitude:136.133478),
        (title:"耳成",latitude:34.512306,longitude:135.814856),
        (title:"三山木",latitude:34.798181,longitude:135.785958),
        (title:"宮町",latitude:34.497381,longitude:136.698761),
        (title:"海山道",latitude:34.942911,longitude:136.622886),
        (title:"明星",latitude:34.531167,longitude:136.642800),
        (title:"向島",latitude:34.914967,longitude:135.769514),
        (title:"六田",latitude:34.390197,longitude:135.822944),
        (title:"室生口大野",latitude:34.566019,longitude:136.015247),
        (title:"元山上口",latitude:34.640217,longitude:135.700883),
        (title:"桃園",latitude:34.663592,longitude:136.477447),
        (title:"桃山御陵前",latitude:34.933353,longitude:135.765469),
        (title:"八木西口",latitude:34.509369,longitude:135.790850),
        (title:"山田川",latitude:34.737444,longitude:135.793694),
        (title:"大和朝倉",latitude:34.516108,longitude:135.869106),
        (title:"大和上市",latitude:34.395558,longitude:135.845608),
        (title:"大和西大寺",latitude:34.693783,longitude:135.782733),
        (title:"大和高田",latitude:34.519867,longitude:135.742358),
        (title:"大和八木",latitude:34.513097,longitude:135.791978),
        (title:"結崎",latitude:34.584189,longitude:135.784708),
        (title:"湯の山温泉",latitude:35.011633,longitude:136.473733),
        (title:"近鉄四日市",latitude:34.967000,longitude:136.618681),
        (title:"志摩横山",latitude:34.334233,longitude:136.817981),
        (title:"吉野口",latitude:34.420558,longitude:135.750653),
        (title:"吉野神宮",latitude:34.390272,longitude:135.848003),
        (title:"伊勢若松",latitude:34.869139,longitude:136.616306),
        (title:"若江岩田",latitude:34.663325,longitude:135.608603),
        (title:"穴川",latitude:34.359008,longitude:136.816011),
        (title:"今川",latitude:34.626181,longitude:135.531111),
        (title:"梅屋敷",latitude:34.683278,longitude:135.686989),
        (title:"大久保",latitude:34.874528,longitude:135.777083),
        (title:"小倉",latitude:34.893233,longitude:135.781758),
        (title:"小俣",latitude:34.512744,longitude:136.685161),
        (title:"柏原",latitude:34.586764,longitude:135.623261),
        (title:"霞ヶ丘",latitude:34.681244,longitude:135.683608),
        (title:"加茂",latitude:34.444047,longitude:136.846597),
        (title:"川西",latitude:34.492333,longitude:135.591000),
        (title:"学園前",latitude:34.697181,longitude:135.750203),
        (title:"九条",latitude:34.6597,longitude:135.783019),
        (title:"黒田",latitude:34.568472,longitude:135.777483),
        (title:"桜",latitude:34.996606,longitude:136.541789),
        (title:"桜井",latitude:34.513142,longitude:135.8467443),
        (title:"三本松",latitude:34.578347,longitude:136.035472),
        (title:"関屋",latitude:34.553778,longitude:135.667883),
        (title:"竹田",latitude:34.956894,longitude:135.756114),
        (title:"千里",latitude:34.798561,longitude:136.556333),
        (title:"筒井",latitude:34.620250,longitude:135.780750),
        (title:"寺田",latitude:34.853375,longitude:135.772133),
        (title:"戸田",latitude:35.132861,longitude:136.807958),
        (title:"長田",latitude:34.678764,longitude:135.591911),
        (title:"額田",latitude:34.675681,longitude:135.651358),
        (title:"東山",latitude:34.648239,longitude:135.708364),
        (title:"瓢箪山",latitude:34.662128,longitude:135.639756),
        (title:"伏見",latitude:34.946211,longitude:135.761267),
        (title:"古市",latitude:34.553575,longitude:135.608864),
        (title:"松尾",latitude:34.432842,longitude:136.840361),
        (title:"松ヶ崎",latitude:34.596464,longitude:136.518731),
        (title:"矢田",latitude:34.605975,longitude:135.532858),
        (title:"吉田",latitude:34.680292,longitude:135.624139),
        (title:"吉野",latitude:34.376931,longitude:135.853508),
        (title:"今里",latitude:34.6647472,longitude:135.5499222),
        (title:"十条",latitude:34.973997,longitude:135.752444),
        (title:"吉野",latitude:34.376931,longitude:135.853508),
        (title:"船津",latitude:34.456942,longitude:136.84155)
        ]
    
    let lCManager = CLLocationManager()
    var nowLocation:CLLocationCoordinate2D!
    var nowLocationMapCheck:Bool!
    var StationPins:[MKPointAnnotation] = []
    
    @IBOutlet weak var stationsMap: MKMapView!
    //locationManagerの設定
    
    func  setPin(t:String,ido:Double,keido:Double){
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: ido, longitude: keido)
        pin.title = t
        stationsMap.addAnnotation(pin)
        StationPins.append(pin)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            nowLocation = location.coordinate
            //カメラセット
            if nowLocationMapCheck == false{
                let center = nowLocation!
                let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
                let region = MKCoordinateRegion(center: center , span: span)
                stationsMap.setRegion(region, animated: true)
                nowLocationMapCheck = true
            }
            
        }
    }
    
    //AnnotationView(詳細)の設定
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let okButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        okButton.setTitle("選択", for:.normal)
        okButton.setTitleColor(UIColor.orange, for:.normal)

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PIN") as? MKPinAnnotationView
        if annotation === mapView.userLocation { // 現在地を示すアノテーションの場合はデフォルトのまま
            return nil
        } else {
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN")
                annotationView?.rightCalloutAccessoryView = okButton
                annotationView?.pinTintColor = .orange
                annotationView?.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }
            return annotationView
        }
    }
    //ボタンが押された
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        KRProgressHUD.show(withMessage: "Loading...")
        
        if let annotation = view.annotation {
            if let title = annotation.title!{
                DispatchQueue(label: "getlink").async{
                    UserDefaults.standard.setValue(title, forKey: "station")
                    var lineLinkData = self.getLinkData(station: title)
                    //tuple -> Array
                    var nameArray = [String]()
                    var directionArray = [String]()
                    var urlArray = [String]()
                    var url_HArray = [String]()
                    for i in 0..<lineLinkData.count{
                        nameArray.append(lineLinkData[i].name)
                        directionArray.append(lineLinkData[i].direction)
                        url_HArray.append(lineLinkData[i].url_H)
                        urlArray.append(lineLinkData[i].url)            }
                    
                    UserDefaults.standard.setValue(nameArray, forKey: "name")
                    UserDefaults.standard.setValue(url_HArray, forKey: "url_H")
                    UserDefaults.standard.setValue(directionArray, forKey: "direction")
                    UserDefaults.standard.setValue(urlArray, forKey: "url")
                    
                    
                    let storyboard: UIStoryboard = self.storyboard!
                    DispatchQueue.main.async {
                        let nextView = storyboard.instantiateViewController(withIdentifier: "SelectLine")
                        KRProgressHUD.dismiss()
                        self.present(nextView, animated: true, completion: nil)
                    }
                    
                }

            }
        }
    }
    
    //各路線の情報を取得
    func getLinkData(station:String) -> [(name:String,direction:String,url:String,url_H:String)]{
        
        let url = NSURL(string: "https://www.kintetsu.co.jp/tetsudo/zenekijikoku.html")
        if var jiObj = Ji(htmlURL: url! as URL){
            var longUrl = NSURL(string: "")
            var res = [String]()
            for i in 1...400 {
                let shortUrl = "/tetsudo_info/zenekijikoku_info.html?pekiname=\(i)"
                let xP:String = "//*[@href='.\(shortUrl)']"
                let bodyNode = jiObj.xPath(xP)
                let string = bodyNode?.first?.content ?? "Station not found"
                //
                if string != "Station not found"{
                    res.append(string)
                }
                
                if station == string{
                    longUrl = NSURL(string: "https://www.kintetsu.co.jp/tetsudo\(shortUrl)")
                }
                
                
            }
            

            //その他3駅
            //津
            var bodyNode = jiObj.xPath("//*[@href='./tetsudo_info/zenekijikoku_info.html?pekiname=17010&type=1']")
            var string = bodyNode?.first?.content ?? "Station not found"
            if station == string{
                longUrl = NSURL(string: "https://www.kintetsu.co.jp/tetsudo/tetsudo_info/zenekijikoku_info.html?pekiname=17010&type=1")
            }
            //八戸ノ里
            bodyNode = jiObj.xPath("//*[@href='./tetsudo_info/zenekijikoku_info.html?pekiname=03008&type=1']")
            string = bodyNode?.first?.content ?? "Station not found"
            if station == string{
                longUrl = NSURL(string: "https://www.kintetsu.co.jp/tetsudo/tetsudo_info/zenekijikoku_info.html?pekiname=03008&type=1")
            }
            //柳
            bodyNode = jiObj.xPath("//*[@href='./tetsudo_info/zenekijikoku_info.html?pekiname=25006&type=1']")
            string = bodyNode?.first?.content ?? "Station not found"
            if station == string{
                longUrl = NSURL(string: "https://www.kintetsu.co.jp/tetsudo/tetsudo_info/zenekijikoku_info.html?pekiname=25006&type=1")
            }
            
            var lineLinkData = [(name:String,direction:String,url:String,url_H:String)]()
            //table[i]...駅
            //eki[i]...駅名
            //table[i]//tr[i]...曜日
            //table[i]//tr[i]//td[i]...方面
            jiObj = Ji(htmlURL: longUrl! as URL)!
            for table in 1...10 {
                
                for td in 1...2{
                    var data = (name:"",direction:"",url: "",url_H: "")
                    bodyNode = jiObj.xPath("//*[@id='main_frame']//table[\(table)]//tr[1]//td[\(td)]/a")
                    let bodyNode_H = jiObj.xPath("//*[@id='main_frame']//table[\(table)]//tr[2]//td[\(td)]/a")
                    let text = bodyNode?.first?.content ?? "ErrorLine"
                    if text != "ErrorLine"{
                        let stationName = jiObj.xPath("//*[@id='main_frame']//p[\(table+1)]")?.first?.content
                        data.name = stationName ?? "Error"
                        data.direction = bodyNode?.first?.content ?? "Error"
                        data.url = bodyNode?.first?["href"] ?? "Error"
                        data.url_H = bodyNode_H?.first?["href"] ?? "Error"
                        lineLinkData.append(data)
                    }
                    
                }
            }
            
            return lineLinkData
            
            
        }
        return [(name:String,direction:String,url:String,url_H:String)]()
    }

    
    //Locationの許可設定が更新されたとき
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            lCManager.startUpdatingLocation()
          
        default:
            lCManager.stopUpdatingLocation()
            
            lCManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        KRProgressHUD.set(style: .custom(background: UIColor.orange, text: UIColor.white, icon: UIColor.white))
        KRProgressHUD.set(activityIndicatorViewColors:([UIColor.white, UIColor.white]))
        KRProgressHUD.set(viewOffset: 0)
        lCManager.delegate = self
        stationsMap.delegate = self
        stationsMap.showsScale = true
        nowLocationMapCheck = false
        for i in stationList {
            setPin(t: i.title, ido: i.latitude, keido: i.longitude)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backToMap(segue: UIStoryboardSegue){
        print("backToMap")
    }
}
