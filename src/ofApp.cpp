#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    //of Setup

    receiver.setup(57123);
    sender.setup("127.0.0.1",  57122);
    
    fboSetup();
    
    ofSetFrameRate(30);
    ofSetBackgroundColor(0,0,0);
    
    maxnumflowers = 3;
    maxnumvines = 2;
    
    flowerSwirlSetup();
}

//--------------------------------------------------------------
void ofApp::update(){
    flowerSwirl.ABreset(sender);

    
    while (receiver.hasWaitingMessages()) {
        ofxOscMessage msg;
        receiver.getNextMessage(msg);
        if (msg.getAddress() == "/stopDrawing"){
            stopDrawing = msg.getArgAsBool(0);
        }
        if (msg.getAddress() == "/clearfbo"){
            fbo = ofFbo();
            fboSetup();
        }
        if (msg.getAddress() == "/setMaxNumFlowers"){
            maxnumflowers = msg.getArgAsInt(0);
        }
        if (msg.getAddress() == "/setMaxNumVines"){
            maxnumvines = msg.getArgAsInt(0);
        }
        if (msg.getAddress() == "/drawSwirl") {
            drawSwirl = msg.getArgAsBool(0);
        }
        if (msg.getAddress() == "/setSwirlSpeed") {
            flowerSwirl.swirlSpeed = msg.getArgAsFloat(0);
        }
        if (msg.getAddress() == "/aGlitch") {
            bool checkGlitch = msg.getArgAsBool(0);
            float glitchSpeed = msg.getArgAsFloat(1);
            
            if (checkGlitch) {
                flowerSwirl.fcflower.fspiral.a = 1.24139981E12;
                flowerSwirl.fcflower.fspiral.b = 1404968.38;
            }
            else {
                flowerSwirl.fcflower.fspiral.a = 1.12051211E12;
                flowerSwirl.fcflower.fspiral.b = 1065468.38;

            //    flowerSwirl.stopA = 1.22139981E12;
            //    flowerSwirl.stopB = 1114968.38;
            }
            
            checkGlitch = false;
        }
        if (msg.getAddress() == "/changeSwirlSize")
        {
            float newAmplitude = msg.getArgAsFloat(0);

            float scaledAmp = ofMap(newAmplitude, 0, 1, 0.025, 25);
            flowerSwirl.fcflower.fspiral.stepLength = scaledAmp;
            swirlCenter.fspiral.stepLength = scaledAmp;
        }
        if (msg.getAddress() == "/slightSwirlIncrease")
        {
            float increase = msg.getArgAsFloat(0);
            flowerSwirl.fcflower.fspiral.stepLength += increase;
            swirlCenter.fspiral.stepLength += increase;
        }

        if (msg.getAddress() == "/newSwirl"){
            flowerCircle tempSwirl;
            tempSwirl = flowerSwirl;
            
            tempSwirl.startA =  9.61320216E+12;
            tempSwirl.startB =  3174365.5;
            tempSwirl.stopA = 1.11609003E+13;
            tempSwirl.stopB = 3428258.75;
            
            tempSwirl.swirlSpeed = 4;
            tempSwirl.fcflower.numPetals = 5;
            tempSwirl.fcflower.fspiral.niter = 50;
            tempSwirl.fcflower.fspiral.a = 0;
            tempSwirl.fcflower.fspiral.b = 0;
            tempFlower.fcflower.fspiral.nColorIter = 200;
            tempSwirl.fcflower.fspiral.stepLength = 2;
            
            swirls.push_back(tempSwirl);

            if (swirls.size() > 2){
                swirls.pop_front();
            }
            
            
        }
        if (msg.getAddress() == "/stopSwirls"){
            while (swirls.size() != 0){
                swirls.pop_back();
            }
        }
        if (msg.getAddress() == "/daisy"){
            float amplitude = msg.getArgAsFloat(1);
            float pan = msg.getArgAsFloat(2);
            
            flowerCircle tempFlower;
            tempFlower.center.x = ofRandom(20, ofGetWidth()-20);
            tempFlower.center.y = int(ofRandom(20, ofGetHeight()) - 20);
            tempFlower.fcflower.fspiral.stepLength = ofMap(amplitude, 0.01, 0.5, 0.05, 2);
            tempFlower.fcflower.fspiral.addNoise = true;
            tempFlower.fcflower.fspiral.niter = 50;
            tempFlower.radius = ofRandom(5, 25);
            
            daisies.push_back(tempFlower);

            if (daisies.size() > maxnumflowers){
                daisies.pop_front();
            }
        }
        if (msg.getAddress() == "/lily"){
            float amplitude = msg.getArgAsFloat(1);
            float pan = msg.getArgAsFloat(2);
            
            
            flowerTri tempFlower;
            tempFlower.center.x = ofRandom(20, ofGetWidth()-20);
            tempFlower.center.y = int(ofRandom(20, ofGetHeight()) - 20);
            tempFlower.fcflower.fspiral.stepLength = ofMap(amplitude, 0.01, 0.5, 1, 3);
            tempFlower.fcflower.fspiral.addNoise = true;
            tempFlower.fcflower.fspiral.niter = 50;
            tempFlower.radius = ofRandom(5, 25);
            tempFlower.startA = 2.4067265E12;
            tempFlower.startB = 1550810.25;
            tempFlower.stopA = 2.88471463E+12;
            tempFlower.stopB = 1705578.75;
            tempFlower.fcflower.fspiral.a = tempFlower.startA;
            tempFlower.fcflower.fspiral.b = tempFlower.startB;
            
            lilies.push_back(tempFlower);

            if (lilies.size() > maxnumflowers){
                lilies.pop_front();
            }
        }
        if (msg.getAddress() == "/patch"){
            float amplitude = msg.getArgAsFloat(1);
            float pan = msg.getArgAsFloat(2);
            
            flowerPatch tempFlower;
            tempFlower.center.x = ofRandom(20, ofGetWidth()-20);
            tempFlower.center.y = int(ofRandom(20, ofGetHeight()) - 20);
            tempFlower.fcflower.fspiral.stepLength = ofMap(amplitude, 0.01, 0.5, 1, 3);
            tempFlower.fcflower.fspiral.addNoise = true;
            tempFlower.fcflower.fspiral.niter = 10;
            tempFlower.radius = ofRandom(1,5);
            tempFlower.startA = 2.4067265E12;
            tempFlower.startB = 1550810.25;
            tempFlower.stopA = 2.88471463E+12;
            tempFlower.stopB = 1705578.75;
            tempFlower.fcflower.fspiral.a = tempFlower.startA;
            tempFlower.fcflower.fspiral.b = tempFlower.startB;
            
            patches.push_back(tempFlower);

            if (patches.size() > 2){
                patches.pop_front();
            }
        }
        if (msg.getAddress() == "/vine"){
                vineSpawnCount++;
                int vineDepth = msg.getArgAsFloat(0);
            
                if (vineSpawnCount % 20 == 0) {
     
                    flowerVine vine;
                    vine.fcflower.fspiral.pos = ofVec3f(ofRandom(20, ofGetWidth()-20),int(ofRandom(20, ofGetHeight()) - 20) );
                    vine.fcflower.fspiral.niter = 100;
                    vine.fcflower.fspiral.stepLength = 0.5;
                    vine.fcflower.fspiral.nColorIter = 50;
                    vine.startA = 0;
                    vine.startB = 0;
                    vine.stopA = 33464286;
                    vine.stopB = 5000;
                    vine.fcflower.fspiral.a = vine.startA;
                    vine.fcflower.fspiral.b = vine.startB;
                    vine.fcflower.fspiral.randomizeColor = false;
                //    vine.fcflower.fspiral.addNoise = true;
                    vine.fcflower.fspiral.deg = false;
                    vine.vineDepth = vineDepth;
                    
                    vines.push_back(vine);

                    if (vines.size() > maxnumvines){
                        vines.pop_front();
                    }
            }
        }
        if (msg.getAddress() == "/stopvine"){
            while (vines.size() != 0){
                vines.pop_back();
            }
           
        }
        if (msg.getAddress() == "/drawBlack"){
                   drawBlack = true;
        }
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    if (stopDrawing){ofSleepMillis(200);} //give my cpu a break
    else {
        if (drawBlack){
            daisies.clear();
            lilies.clear();
            patches.clear();
            swirls.clear();
            vines.clear();
            fbo.begin();
            ofBackground(0, 0, 0);
            fbo.end();
            fbo.draw(0,0);
            drawBlack = false;
            ofSleepMillis(20);
        }
        fbo.begin();
        ofSetColor(255,255,255);
            for (auto flwr : daisies){
                flwr.draw();}
            for (auto flwr : lilies){
                flwr.draw();}
            for (auto flwr : patches){
                flwr.draw();}
            for (auto flwr : swirls){
                flwr.draw();}
            for (auto flwr : vines){
                flwr.draw();}
            
            daisies.clear(); //I dont want the daisies to get fat like that
        fbo.end();
        fbo.draw(0,0);

        if (drawSwirl){
            cout<<flowerSwirl.swirlSpeed<<endl;
               swirlCenter.draw();
               flowerSwirl.draw();
        }

        ofSetColor(255,255,255);
    }

}

//--------------------------------------------------------------
void ofApp::flowerSwirlSetup(){
    flowerSwirl.startA = 1.12051211E12;
    flowerSwirl.startB = 1065468.38;
    flowerSwirl.stopA = 1.20139981E12;
    flowerSwirl.stopB = 1104968.38;
//    flowerSwirl.stopA = 1.22139981E12;
//    flowerSwirl.stopB = 1114968.38;
    
    flowerSwirl.swirl = true;
    flowerSwirl.swirlDepth = flowerSwirl.radius/10;
    flowerSwirl.fcflower.numPetals = 5;
    flowerSwirl.fcflower.fspiral.niter = 50;
    flowerSwirl.fcflower.fspiral.a = flowerSwirl.startA;
    flowerSwirl.fcflower.fspiral.b = flowerSwirl.startB;
    flowerSwirl.fcflower.fspiral.stepLength = 2.5;
    flowerSwirl.fcflower.fspiral.nColorIter = 2000;
    flowerSwirl.radius = 100;
    flowerSwirl.fcflower.fspiral.lineWidth = 5;
    swirlCenter = flowerSwirl.fcflower;
    swirlCenter.fspiral.lineWidth = 1;
    flowerSwirl.center = ofVec3f(ofGetWidth()/2, ofGetHeight()/2);
    flowerSwirl.fcflower.fspiral.randomizeColor = true;

}

void ofApp::fboSetup(){
    fbo.clear();
    ofClear(0,0,0);
    fbo.allocate(ofGetWidth(), ofGetHeight());
    
    fbo.begin();
    ofSetBackgroundColor(0, 0, 0);
    fbo.end();
}


// the object trash
/*
 flowerDipole.startA = 2.4067265E12;
 flowerDipole.startB = 1550810.25;
 flowerDipole.stopA = 2.88471463E+12;
 flowerDipole.stopB = 1705578.75;
 
 flowerDipole.fcflower.numPetals = 5;
 flowerDipole.fcflower.fspiral.niter = 50;
 flowerDipole.fcflower.fspiral.a = flowerDipole.startA;
 flowerDipole.fcflower.fspiral.b = flowerDipole.startB;
 flowerDipole.fcflower.fspiral.stepLength = 2;
 
 flowerTremolo.startA =  9.61320216E+12;
 flowerTremolo.startB =  3174365.5;
 flowerTremolo.stopA = 1.11609003E+13;
 flowerTremolo.stopB = 3428258.75;
 
 flowerTremolo.fcflower.numPetals = 5;
 flowerTremolo.fcflower.fspiral.niter = 50;
 flowerTremolo.fcflower.fspiral.a = 0;
 flowerTremolo.fcflower.fspiral.b = 0;
 flowerTremolo.fcflower.fspiral.stepLength = 2;
 
 flowerHuge.startA = 1.08882769E+12;
 flowerHuge.startB = 1873685.25;
 flowerHuge.stopA = 1.10020618E+12;
 flowerHuge.stopB = 1877060.25;
 
 flowerHuge.fcflower.numPetals = 5;
 flowerHuge.fcflower.fspiral.niter = 50;
 flowerHuge.fcflower.fspiral.a = 0;
 flowerHuge.fcflower.fspiral.b = 0;
 flowerHuge.fcflower.fspiral.stepLength = 2;
 
 maxCurrentStableStepLength = 17.010294
 */




            //add a way to prevent the flower from spawning around the center swirl
//                       while                              ( ((tempFlower.center.x - (flowerSwirl.center.x - (flowerSwirl.radius - 50)) < 0)
//                                                             &&
//                                                             (tempFlower.center.x - (flowerSwirl.center.x + (flowerSwirl.radius + 50)) > 0))
//                                                            ||
//                                                            ((tempFlower.center.y - (flowerSwirl.center.y - (flowerSwirl.radius - 50)) < 0)
//                                                             &&
//                                                             (tempFlower.center.y - (flowerSwirl.center.y + (flowerSwirl.radius + 50)) > 0)))
//                        {
//                            tempFlower.center.x = ofRandom(20, ofGetWidth()-20);
//                            tempFlower.center.y = int(ofRandom(20, ofGetHeight()) - 20);
//                        }
