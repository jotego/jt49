package main

import(
	"fmt"
)

const roff_small=3e6
const ron_large =900
const scale=1.55
const vdd=5.0

var goff, gon [16]float64

func conductance(a int) (g float64) {
	g = 0
	a&=0xf
	for k:=0;k<16;k++ {
		if k==a {
			g += gon[k]
		} else {
			g += goff[k]
		}
	}
	return g
}

func fill_glut() {
	goff[0]=1.0/roff_small
	for k:=1; k<16;k++ {
		goff[k] = goff[k-1]*scale
	}
	gon[15]=1.0/ron_large
	for k:=14;k>=0;k-- {
		gon[k] = gon[k+1]/scale
	}
	// for k:=0;k<16;k++ {
	// 	fmt.Printf("%e,%e\n",goff[k],gon[k])
	// }
}

func vout(rout, rload float64) float64 {
	return rload/(rload+rout)*vdd
}

func single_output(rload float64) {
	for k:=0; k<0x10; k++ {
		rt := 1.0/conductance(k)
		fmt.Printf("%02d,%.0f Ohm,%f V\n",k,rload,vout(rt, rload))
	}
}

// func
// 	for k:=0; k<0x400; k++ {
// 		g1 := conductance(k)
// 		g2 := conductance(k>>4)
// 		g3 := conductance(k>>8)
// 		gt = g1+g2+g3
// 	}
func main() {
	fill_glut()
	single_output(1000)
	single_output(10000)
}