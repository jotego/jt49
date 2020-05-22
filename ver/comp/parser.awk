BEGIN {
    for( i=0; i<4096; i++ )
        mem[i]=0x300
    cnt=0
}
function add_cmd(val) {
    mem[cnt]=val
    cnt=cnt+1
}
function validate_ch(c) {
    if( ch!="a" && ch!="b" && ch!="c" && ch!="no" && ch!="env" ) {
        print "ERROR: bad channel at line " FNR ". Used '" ch "'" > "/dev/stderr"
        exit 1
    }
}
function validate_arg(val,min,max) {
    if( val<min || val>max ) {
        print "ERROR: value should be bettwen " min " and " max " at " FNR > "/dev/stderr"
        exit 1
    }
}
/vol / {
    allargs=substr($0,4)
    gsub( " ", "", allargs )
    split( allargs, cmdargs, "," )
    ch=cmdargs[1]
    val=strtonum(cmdargs[2])
    validate_ch(ch)
    if( ch=="a" ) ch=8
    else if( ch=="b" ) ch=9
    else if( ch=="c" ) ch=10
    validate_arg( val, 0, 0x1f )
    add_cmd( 0x100 + ch ) # address
    add_cmd( val )
    next
}
/period / {
    allargs=substr($0,7)
    gsub( " ", "", allargs )
    split( allargs, cmdargs, "," )
    ch=cmdargs[1]
    val=strtonum(cmdargs[2])
    validate_ch(ch)
    if( ch=="a" ) ch=0
    else if( ch=="b" ) ch=2
    else if( ch=="c" ) ch=4
    else if( ch=="no") ch=6
    else if( ch=="env") ch=013
    if( ch<6 || ch==013) {
        lsb=val%256
        msb=(val-lsb)/256
        if( ch==6   ) validate_arg( val, 0, 0xfff  )
        if( ch==013 ) validate_arg( val, 0, 0xffff )
        add_cmd( 0x100 + ch ) # address
        add_cmd( lsb )
        add_cmd( 0x100 + ch +1 ) # address
        add_cmd( msb )
    } else if(ch==6) { # Noise
        lsb=val%32
        add_cmd( 0x100 + ch ) # address
        add_cmd( lsb )    
    }
    next
}
/shape/ {
    allargs=substr($0,6)
    gsub(" ", "", allargs)
    val=strtonum(allargs)
    validate_arg( val, 0, 0xf)
    add_cmd(0x100+015 ) # Octal!
    add_cmd(val)
    next
}
/^#/ {
    next
}
/wait / {
    split( $0, cmdargs, " " )
    waitcnt=strtonum(cmdargs[2])
    if(waitcnt>255 || waitcnt==0) {
        print "ERROR: wait cannot be longer than 255 or be zero. " waitcnt " was used."
        exit 1
    }
    add_cmd(0x200 + waitcnt)
    next
}
/finish/ {
    add_cmd(0x300)
    next
}
{
    print "ERROR: cannot parse line " $0 > "/dev/stderr"
    exit 1
}
END {
    for( i=0; i<cnt; i++ ) {
        printf "%3X\n",mem[i]
    }
}