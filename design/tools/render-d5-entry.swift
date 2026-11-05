// Static design renderer only; no game or authentication implementation.
import AppKit
import CoreText
import CryptoKit
func read(_ p:String)->[String:Any]{try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:p))) as! [String:Any]}
let spec=read("design/states/D5-entry-spec.json"), tokens=read("design/states/D5-entry-trial-tokens.json")
let g=tokens["geometry"] as! [String:Int]
let roles=(read("design/states/D1-canonical-render-matrix.json")["typeTrial"] as! [String:Any])["roles"] as! [String:[String:Int]]
let refs=read("design/states/D6-canonical-token-proposal.json")["referenceColors"] as! [String:[String:String]]
func color(_ k:String)->NSColor{let v=UInt32(refs[k]!["value"]!.dropFirst(),radix:16)!;return NSColor(srgbRed:CGFloat((v>>16)&255)/255,green:CGFloat((v>>8)&255)/255,blue:CGFloat(v&255)/255,alpha:1)}
let manifest=read("design/states/D1-font-binary-manifest.json")["fonts"] as! [[String:Any]]
let f=manifest.first{$0["id"] as! String == "NotoSans"}!
let data=try! Data(contentsOf:URL(fileURLWithPath:f["path"] as! String))
precondition(SHA256.hash(data:data).map{String(format:"%02x",$0)}.joined()==f["sha256"] as! String)
let cg=CGFont(CGDataProvider(data:data as CFData)!)!
func font(_ role:String)->CTFont{let r=roles[role]!;let d=CTFontDescriptorCreateWithAttributes([kCTFontVariationAttribute:[NSNumber(value:0x77676874):NSNumber(value:r["weight"]!),NSNumber(value:0x77647468):100]] as CFDictionary);return CTFontCreateWithGraphicsFont(cg,CGFloat(r["sizeSp"]!*2),nil,d)}
var checks:[[String:Any]]=[],resolved=Set<String>()
func box(_ x:Int,_ y:Int,_ w:Int,_ h:Int,_ c:String){color(c).setFill();NSRect(x:x,y:y,width:w,height:h).fill()}
func text(_ str:String,_ role:String,_ x:Int,_ y:Int,_ w:Int,_ h:Int,_ c:String="nav",_ capture:String){
 let a=NSAttributedString(string:str,attributes:[.font:font(role),.foregroundColor:color(c)])
 let ts=CTTypesetterCreateWithAttributedString(a);var i=0,yy=y
 let lh=roles[role]!["lineHeightSp"]!*2
 while i<a.length {let n=CTTypesetterSuggestLineBreak(ts,i,Double(w));precondition(n>0);let line=CTTypesetterCreateLine(ts,CFRange(location:i,length:n));let ctx=NSGraphicsContext.current!.cgContext
 ctx.saveGState();ctx.translateBy(x:CGFloat(x),y:CGFloat(yy)+CTFontGetAscent(font(role)));ctx.scaleBy(x:1,y:-1);ctx.textPosition = .zero;CTLineDraw(line,ctx);ctx.restoreGState()
 for run in CTLineGetGlyphRuns(line) as! [CTRun]{let attr=CTRunGetAttributes(run) as NSDictionary;resolved.insert(CTFontCopyPostScriptName(attr[kCTFontAttributeName] as! CTFont) as String)}
 yy+=lh;i+=n
 }
 checks.append(["capture":capture,"text":str,"rect":[x,y,w,h],"neededHeight":yy-y,"fits":yy-y<=h,"safe":x>=0 && y>=g["safeTop"]! && x+w<=g["width"]! && y+h<=g["height"]!-g["safeBottom"]!])
}
let dir="design/states/D5-entry-v1"
for s in spec["states"] as! [[String:String]] {
 let id=s["id"]!,w=g["width"]!,h=g["height"]!,x=g["contentX"]!,cw=g["contentWidth"]!,inset=g["textInset"]!
 let bitmap=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:w,pixelsHigh:h,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
 NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:bitmap)
 let ctx=NSGraphicsContext.current!.cgContext;ctx.translateBy(x:0,y:CGFloat(h));ctx.scaleBy(x:1,y:-1)
 box(0,0,w,h,"paper");box(0,0,g["identityWidth"]!+g["margin"]!,h,"nav")
 text("BARTERUNE","screenTitle",48,104,352,56,"paper",id)
 text("Tacir macəran\nsəni gözləyir.","body",48,184,352,144,"paper",id)
 text("Dil: Azərbaycan dili","supporting",48,536,352,80,"paper",id)
 text(s["title"]!,"screenTitle",x,g["titleY"]!,cw,80,"nav",id)
 text(s["body"]!,"body",x,g["bodyY"]!,cw,144,"nav",id)
 if id == "F01-language" {
 for (i,label) in ["✓ Azərbaycan dili","Türkçe","Русский","English"].enumerated(){let bx=x+(i%2)*(g["languageWidth"]!+g["languageGap"]!),by=i<2 ? g["languageY"]!:g["languageRow2Y"]!
 text(label,"label",bx+inset,by+inset,g["languageWidth"]!-2*inset,g["buttonHeight"]!-2*inset,"nav",id)
 }
 } else {text(s["note"]!,"supporting",x,g["noteY"]!,cw,72,"nav",id)}
 for (key,yk) in [("primary","primaryY"),("secondary","secondaryY")] {
 let label=s[key]!;if label.isEmpty{continue};let y=id == "F01-language" ? g["secondaryY"]!:g[yk]!,bh=g["buttonHeight"]!
 if key=="primary"{box(x,y,cw,bh,"nav")}
 text(label,"label",x+inset,y+inset,cw-2*inset,bh-2*inset,key=="primary" ? "paper":"nav",id)
 }
 text("Məxfilik","supporting",x+inset,g["footerY"]!,cw-2*inset,40,"nav",id)
 NSGraphicsContext.restoreGraphicsState()
 try! bitmap.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:"\(dir)/\(id).png"))
}
let report:[String:Any]=["checks":checks,"resolvedFonts":Array(resolved).sorted(),"fontHash":f["sha256"]!,"allFit":checks.allSatisfy{$0["fits"] as! Bool},"allSafe":checks.allSatisfy{$0["safe"] as! Bool},"controlTargetPx":[g["contentWidth"]!,g["buttonHeight"]!],"limits":"Static AZ P1 only. Footer privacy has 48dp hit region in design; URL not configured. Native selector not captured."]
try! JSONSerialization.data(withJSONObject:report,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:"\(dir)/verification.json"))
print("Rendered 16 entry screens; fits=\(report["allFit"]!), safe=\(report["allSafe"]!)")
let states=spec["states"] as! [[String:String]]
let overview=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:1280,pixelsHigh:2880,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:0,bitsPerPixel:0)!
NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:overview)
for (i,s) in states.enumerated(){let img=NSImage(contentsOfFile:"\(dir)/\(s["id"]!).png")!;img.draw(in:NSRect(x:(i%2)*640,y:2880-(i/2+1)*360,width:640,height:360))}
NSGraphicsContext.restoreGraphicsState();try! overview.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:"\(dir)/overview.png"))
