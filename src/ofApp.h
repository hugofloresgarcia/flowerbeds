#pragma once

#include "ofMain.h"
#include "flower.hpp"
#include "ofxOsc.h"

class ofApp : public ofBaseApp{

public:
    void setup();
    void update();
    void draw();
    
    bool stopDrawing = false;
    bool drawBlack = false;

    void fboSetup();
    
    void flowerSwirlSetup();

    ofFbo fbo;
    
    int maxnumflowers;
    int maxnumvines;
    
    flowerCircle tempFlower;
    
    int vineSpawnCount;
    
    flowerCircle flowerSwirl = flowerCircle();
    flower swirlCenter = flower();
    bool checkGlitch;
    
    list<flowerCircle> daisies;
    list<flowerTri> lilies;
    list<flowerPatch> patches;
    list<flowerVine> vines;
    list<flowerCircle> swirls;
    ofxOscReceiver receiver;
    ofxOscSender sender;
    
    bool drawSwirl;
    
    flowerVine vine;

        
};
