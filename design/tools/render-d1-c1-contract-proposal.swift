// Static composition experiment only. No app/game implementation.
import AppKit
import CoreText
import CryptoKit
func read(_ p:String)->[String:Any]{try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:p))) as! [String:Any]}
let dir="design/states/D1-C1-contract-proposal"
try! FileManager.default.createDirectory(atPath:dir,withIntermediateDirectories:true)
let matrix=read("design/states/D1-canonical-render-matrix.json")
let roles=(matrix["typeTrial"] as! [String:Any])["roles"] as! [String:[String:Int]]
let fixture=read("design/states/D1-render-fixture.json"), manifest=read("design/states/D1-font-binary-manifest.json")
let base=fixture["base"] as! [String:Any], goods=base["goods"] as! [[String:Any]]
let loc=(read("design/states/D1-render-localization.json")["strings"] as? [String:[String:String]])
let localization=read("design/states/D1-render-localization.json")
let strings=(localization["languages"] as? [String:[String:String]]) ?? loc ?? [:]
let ru=strings["RU"]!
let refs=read("design/states/D6-canonical-token-proposal.json")["referenceColors"] as! [String:[String:String]]
func color(_ k:String)->NSColor{let v=UInt32(refs[k]!["value"]!.dropFirst(),radix:16)!;return NSColor(srgbRed:CGFloat((v>>16)&255)/255,green:CGFloat((v>>8)&255)/255,blue:CGFloat(v&255)/255,alpha:1)}
func t(_ k:String,_ values:[String:String]=[:])->String{var s=ru[k]!;for(k,v) in values{s=s.replacingOccurrences(of:"{\(k)}",with:v)};return s}
var fonts:[String:CTFont]=[:], fontEvidence:[[String:Any]]=[]
for f in manifest["fonts"] as! [[String:Any]] {
 let data=try! Data(contentsOf:URL(fileURLWithPath:f["path"] as! String));let hash=SHA256.hash(data:data).map{String(format:"%02x",$0)}.joined();precondition(hash==f["sha256"] as! String)
 let cg=CGFont(CGDataProvider(data:data as CFData)!)!
 for w in [400,600,700]{let variation:[NSNumber:NSNumber]=[NSNumber(value:0x77676874):NSNumber(value:w),NSNumber(value:0x77647468):100]
 let desc=CTFontDescriptorCreateWithAttributes([kCTFontVariationAttribute:variation] as CFDictionary)
 let font=CTFontCreateWithGraphicsFont(cg,64,nil,desc);fonts["\(f["id"]!)-\(w)"]=font
 fontEvidence.append(["source":f["path"]!,"sha256":hash,"requestedWeight":w,"requestedWidth":100,"resolvedName":CTFontCopyPostScriptName(font),"resolvedAxes":Dictionary(uniqueKeysWithValues: (CTFontCopyVariation(font) as? [NSNumber:NSNumber] ?? [:]).map{ (String($0.key.intValue), $0.value.doubleValue) })])
 }
}

// Explanatory diagram only; editorial text size is not UI typography.
let W=2080, H=1680
var textChecks:[[String:Any]]=[]
let bitmap=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:W,pixelsHigh:H,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:bitmap)
let c=NSGraphicsContext.current!.cgContext;c.translateBy(x:0,y:CGFloat(H));c.scaleBy(x:1,y:-1)
c.setFillColor(color("paper").cgColor);c.fill(CGRect(x:0,y:0,width:W,height:H))
func rect(_ x:CGFloat,_ y:CGFloat,_ w:CGFloat,_ h:CGFloat,_ filled:Bool=false){
 c.setStrokeColor(color("nav").cgColor);c.setLineWidth(2)
 if filled{c.setFillColor(color("nav").cgColor);c.fill(CGRect(x:x,y:y,width:w,height:h))}else{c.stroke(CGRect(x:x,y:y,width:w,height:h))}
}
func text(_ s:String,_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ size:CGFloat=32,_ bold:Bool=false,_ reverse:Bool=false){
 let f=CTFontCreateCopyWithAttributes(fonts[bold ? "NotoSans-600":"NotoSans-400"]!,size,nil,nil)
 let a=NSAttributedString(string:s,attributes:[.font:f,.foregroundColor:color(reverse ? "paper":"nav")]);let ts=CTTypesetterCreateWithAttributedString(a);var i=0;var yy=y
 while i<a.length{let n=CTTypesetterSuggestLineBreak(ts,i,Double(width));precondition(n>0);let line=CTTypesetterCreateLine(ts,CFRange(location:i,length:n));c.saveGState();c.translateBy(x:x,y:yy+CTFontGetAscent(f));c.scaleBy(x:1,y:-1);c.textPosition = .zero;CTLineDraw(line,c);c.restoreGState();yy+=size*1.4;i+=n}
 textChecks.append(["text":s,"bottomPx":yy,"rightLimitPx":x+width]);precondition(yy<CGFloat(H))
}
text("P1 C1 — nəyi dəyişməyi təklif edirəm?",48,32,1984,48,true)
text("Müqavilə təklifi · təsdiqlənməyib · oyun implementasiyası yoxdur",48,112,1984)
text("Bu, izah sxemidir. Çərçivələr P1 ölçüsündə ekran və şrift sınağı deyil.",48,168,1984,28)
text("İNDİ: HAMISI EYNİ KADRDA",48,248,928,34,true)
text("TƏKLİF: EYNİ VƏZİYYƏT, AYRI BÖLMƏLƏR",1104,248,928,32,true)
rect(48,320,928,760)
rect(48,320,928,104,true)
text("Cari HUD · 500 pul · yük 16/40",80,344,864,32,true,true)
text("Siyahının başlanğıcı + seçilmiş Parça",80,456,864,32,true)
text("Malın bütün məlumatları",80,544,864,32,true)
text("Sağlam və zədəli partiyanın bütün detalları",80,632,864,32,true)
text("Ayrı alış preview-si + ayrı satış preview-si",80,752,864,32,true)
text("Bunların hamısı eyni kadrda görünməlidir.",80,896,864,32,true)
text("Son ölçülən variant: 2528 px tələb / 624 px mövcud.",80,984,864,28)
text("C1 hazırda keçmir.",48,1128,928,36,true)
text("Bu ölçmə yalnız son sınaq kompozisiyasına aiddir; bütün mümkün düzülüşlərin mümkünsüzlüyünü sübut etmir.",48,1200,928,28)
// Proposed section cards. These are information architecture diagrams, not UI captures.
for (index,title,content) in [
 (0,"1 · MAL","Ad + miqdar 2\nQiymət 35/28 · ehtiyat 30\nSəndə 8 · vahid yükü 2"),
 (1,"2 · PARTİYALAR","Sağlam: seçilmiş · 100% · say 5 · maya 24 · marja 4\nZədəli: seçilməmiş · 60% · say 3 · maya 20\nMarja izahı ayrıca saxlanır."),
 (2,"3 · ÖNİZLƏMƏ","Alış: cəmi 70 · pul 430 · yük 20/40\nSatış: cəmi 56 · pul 556 · yük 12/40\nAyrı bloklar; lazım olsa alt-alta və sürüşmə ilə.")
] {
 let y=CGFloat(320+index*304)
 rect(1104,y,928,280);rect(1104,y,928,72,true)
 text(title+"  |  HUD görünür",1136,y+12,864,30,true,true)
 // Explicit newline paragraphs, not UI labels or replacement localized strings.
 var ty=y+88
 for line in content.components(separatedBy:"\n"){text(line,1136,ty,864,26);ty+=56}
}
text("Siyahı ayrıca açılır; başlanğıcı ayrıca capture ilə yoxlanır.",1104,1256,928,28)
rect(48,1408,1984,208)
text("DƏYİŞƏN: “eyni kadr” tələbi → eyni vəziyyət üzrə bir neçə capture.",80,1432,1920,32,true)
text("QORUNAN: bütün məlumatlar, şrift ölçüləri, seçilmiş mal/partiya/miqdar. Bölmə keçidi əməliyyat etmir. C2 dəyişmir.",80,1496,1920,28)
NSGraphicsContext.restoreGraphicsState()
try! bitmap.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:"\(dir)/comparison.png"))
try! JSONSerialization.data(withJSONObject:["status":"unapproved_contract_explanation_only","notViewportRender":true,"notTypographyValidation":true,"source":"Same candidate paper/nav palette and pinned Noto Sans; editorial diagram text is not proposed UI type","textChecks":textChecks],options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"\(dir)/manifest.json"))
print("Saved explanatory PNG")
