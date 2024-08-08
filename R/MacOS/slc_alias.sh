slc() {
 
       if [ -z "$1" ]; then
              echo "Usage: slc <filename>"
              return 1
       fi
      
       local filename="$1"
 
       /applications/AltairSLC.app/Contents/MacOS/wps "$filename"
 
       local base_name=${filename%.*}
       cat "${base_name}.log"
 
}