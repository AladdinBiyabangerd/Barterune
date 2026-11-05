// Static composition experiment only. No app/game implementation.
import AppKit
import CoreText
import CryptoKit
func read(_ p:String)->[String:Any]{try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:p))) as! [String:Any]}
let dir="design/states/D1-C1-navigation-v1"
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


// Editorial navigation storyboard. Source captures are embedded at native 1280x720.
let W=2720, H=3400
let bitmap=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:W,pixelsHigh:H,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:bitmap)
let c=NSGraphicsContext.current!.cgContext;c.translateBy(x:0,y:CGFloat(H));c.scaleBy(x:1,y:-1)
c.setFillColor(color("paper").cgColor);c.fill(CGRect(x:0,y:0,width:W,height:H))
func text(_ s:String,_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ size:CGFloat=32,_ bold:Bool=false){
 let f=CTFontCreateCopyWithAttributes(fonts[bold ? "NotoSans-600":"NotoSans-400"]!,size,nil,nil)
 let a=NSAttributedString(string:s,attributes:[.font:f,.foregroundColor:color("nav")]);let ts=CTTypesetterCreateWithAttributedString(a);var i=0;var yy=y
 while i<a.length{let n=CTTypesetterSuggestLineBreak(ts,i,Double(width));precondition(n>0);let line=CTTypesetterCreateLine(ts,CFRange(location:i,length:n));c.saveGState();c.translateBy(x:x,y:yy+CTFontGetAscent(f));c.scaleBy(x:1,y:-1);c.textPosition = .zero;CTLineDraw(line,c);c.restoreGState();yy+=size*1.4;i+=n};precondition(yy<CGFloat(H))
}
func line(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat){c.setStrokeColor(color("nav").cgColor);c.setLineWidth(2);c.move(to:CGPoint(x:x,y:y));c.addLine(to:CGPoint(x:x+width,y:y));c.strokePath()}
text("C1 · Bölmə naviqasiyası — statik təklif",48,24,2624,48,true)
text("Kadrlar dəyişmədən, 1:1 ölçüdədir. Keçid zolaqları ekranın xaricində izahdır; P1 fit təsdiqi deyil.",48,104,2624)
text("Yol A: 1 → 2 → 3 → 4; geri: 4 → 3 → 2 → 1. Yol B: 3 → 5 → 6; geri: 6 → 5 → 3.",48,160,2624,32,true)
let cards:[(String,String,String,String)] = [
 ("C1-list-start-1","1 · Siyahı başlanğıcı","Parça detalına keç → 2","Geri: bu sxemin sərhədi; siyahıdan çıxış ayrıca qərardır."),
 ("C1-good-1","2 · Mal","Partiyalar → 3   |   Önizləmə → 5","‹ Geri → 1 · siyahının əvvəlki mövqeyinə"),
 ("C1-batch-healthy-1","3 · Partiyalar / sağlam · seçilmiş","Digər partiyaya bax → 4   |   Önizləmə → 5","‹ Geri → əvvəlki bölmə; nümunədə Mal (2)"),
 ("C1-batch-damaged-1","4 · Partiyalar / zədəli · seçilməmiş","‹ Sağlam partiyaya qayıt → 3","‹ Geri → 3 · baxış dəyişir, seçilmiş partiya dəyişmir"),
 ("C1-preview-buy-1","5 · Önizləmə / alış","Satış önizləməsinə bax → 6","‹ Geri → açıldığı bölmə; nümunədə sağlam partiya (3)"),
 ("C1-preview-sell-1","6 · Önizləmə / satış","‹ Alış önizləməsinə qayıt → 5","‹ Geri → 5 · sonra geri ilə əvvəlki bölməyə")
]
for (i,item) in cards.enumerated(){
 let x=CGFloat(48+(i%2)*1344),y=CGFloat(256+(i/2)*960)
 text(item.1,x,y,1280,36,true)
 let im=NSImage(contentsOfFile:"design/states/D1-C1-margin-v3/\(item.0).png")!
 var r=CGRect(x:0,y:0,width:1280,height:720);let cg=im.cgImage(forProposedRect:&r,context:nil,hints:nil)!
 precondition(cg.width==1280 && cg.height==720)
 c.saveGState();c.translateBy(x:x,y:y+64+720);c.scaleBy(x:1,y:-1);c.draw(cg,in:CGRect(x:0,y:0,width:1280,height:720));c.restoreGState()
 line(x,y+792,1280);text(item.2,x,y+808,1280,30,true);text(item.3,x,y+860,1280,28)
}
text("QAYIDIŞ QAYDASI · Təklif, canlı yoxlama deyil",48,3160,2624,36,true)
text("Hər keçid əvvəlki bölmə + baxış mövqeyi + fokus yerini saxlamalıdır. Geri onları bərpa etməlidir.",48,3224,2624,30)
text("Parça / sağlam partiya / miqdar 2 sabitdir. Baxış və bölmə keçidi seçim və əməliyyat etmir. C2 dəyişmir.",48,3280,2624,30)
NSGraphicsContext.restoreGraphicsState()
try! bitmap.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:"\(dir)/navigation.png"))
print("Saved static navigation storyboard")
