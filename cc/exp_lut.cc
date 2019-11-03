#include <iostream>
#include <cmath>

using namespace std;

int main() {
    float ex[4] = {4,6,8,13};
    int lut[4][32];
    for( int i=0; i<4; i++ ) {
        float f=255;
        float e=1.0/pow(2, 1.0/ex[i] );
        // cout << e << '\n';
        lut[i][31]=255;
        for(int j=30; j>0; j-- ) {
            f=f*e;
            lut[i][j] = (int)f;
        }
        lut[i][0]=0;
    }
    for( int i=0; i<4; i++)
        for( int j=0; j<32; j++ ) {
            int v = (i<<5)|j;
            cout << "\tlut[" << v << "] = 8'd" << lut[i][j] << ";\n";
        }
}