import AppKit
import CryptoKit
func read(_ p:String)->[String:Any]{try! JSONSerialization.jsonObject(with:Data(contentsOf:URL(fileURLWithPath:p))) as! [String:Any]}
func digest(_ p:String)->String {
 let im=NSImage(contentsOfFile:p)!.cgImage(forProposedRect:nil,context:nil,hints:nil)!
 var bytes=[UInt8](repeating:0,count:im.width*im.height*4)
 bytes.withUnsafeMutableBytes{ buf in let c=CGContext(data:buf.baseAddress,width:im.width,height:im.height,bitsPerComponent:8,bytesPerRow:im.width*4,space:CGColorSpaceCreateDeviceRGB(),bitmapInfo:CGImageAlphaInfo.premultipliedLast.rawValue)!;c.draw(im,in:CGRect(x:0,y:0,width:im.width,height:im.height)) }
 return SHA256.hash(data:Data(bytes)).map{String(format:"%02x",$0)}.joined()
}
let old="design/states/D2-payment-control-extension-v15",new="design/states/D2-payment-control-matrix-v15"
var count=0,mismatches=[String]()
for c in read(old+"/measurements.json")["cases"] as! [[String:Any]] {autoreleasepool {
 let prefix=(c["id"] as! String).components(separatedBy:"-").prefix(4).joined(separator:"-")
 let key=prefix+"-"+(c["fixture"] as! String)+"-"+(c["interaction"] as! String)
 for (i,p) in (c["pages"] as! [[String:Any]]).enumerated() {
  let target=new+"/"+key+"-\(i).png"
  if FileManager.default.fileExists(atPath:target) {if digest(p["path"] as! String) != digest(target){mismatches.append(target)};count+=1}
 }
}}
let r:[String:Any]=["comparedCaptures":count,"mismatches":mismatches]
try! JSONSerialization.data(withJSONObject:r,options:[.prettyPrinted,.sortedKeys]).write(to:URL(fileURLWithPath:new+"/extension-pixel-regression.json"))
print("Compared \(count); mismatches \(mismatches.count)")

precondition(count == 545 && mismatches.isEmpty, "Accepted extension pixel regression failed")
