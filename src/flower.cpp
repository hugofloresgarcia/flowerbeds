//
//  flower.cpp
//  flowers
//
//  Created by Hugo Flores Garcia on 1/28/20.
//

#include "flower.hpp"
#include "ofMain.h"

// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
spiral::spiral(ofVec3f center, int _niter, float _stepLength){
    pos = center;
    niter = _niter;
    stepLength = _stepLength;
    
    color.set(ofRandom(128,255),
    ofRandom(128,255),
    ofRandom(128,255));
}

void spiral::draw(){
    for (int i = 0; i < niter ; ++i){
        
        oldPos = pos;

        a += b;
        
        if (addNoise == true){
            b += .5 * DEG_TO_RAD + ofNoise(ofGetElapsedTimef()*(0.5 + noiseIndex) + 30);
        }
        else if (deg) {
            b += .5;
        }
        else {
            b += .5 * DEG_TO_RAD;
        }

        ofPoint distance(cos(a), sin(a));
        
        pos = pos + stepLength * distance;
        
        if (randomizeColor){
            if (colorStep % nColorIter == 0){
                //generate random color
                if (darkColors){
                    color = ofColor (ofRandom(128,0),
                    ofRandom(128,0),
                     ofRandom(128,0));
                }
                else{
                    color = ofColor (ofRandom(128,192),
                                    ofRandom(128,192),
                                     ofRandom(128,192));
                }
            }
        }
        ofSetColor(color);
//        ofSetLineWidth(lineWidth);
        ofDrawLine(oldPos, pos);
    }
}

// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

flower::flower(spiral _fspiral, int _numPetals, ofVec3f _center){
    fspiral = _fspiral;
    numPetals = _numPetals;
    center = _center;
}

void flower::draw(){
    for(int i = 0; i<numPetals ; ++i){
        ofPushMatrix();
            ofTranslate(center.x, center.y);
            ofRotateDeg(360/(numPetals*(i+1)));
            fspiral.draw();
            fspiral.colorStep += 1;
            fspiral.pos.set(0,0);
        ofPopMatrix();
    }
}

// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


flowerCircle::flowerCircle(flower _fcflower, float _radius, ofVec3f _center, int _numElements){
    radius = _radius;
    fcflower = _fcflower;
    center = _center;
    numElements = _numElements;
    angle = 0;
}

void flowerCircle::draw(){
//    center.y -= radius * 11;
    //draw the center first
    fcflower.center = center;
    fcflower.draw();

    for (int i = 0; i < numElements ; ++i){
        float oldRadius = radius;
        swirlDepth = radius/2;
        if (swirl) {
            radius = radius + swirlDepth * sin(2 * M_PI * swirlSpeed * ofGetElapsedTimef());
        }
        
        
        fcflower.center.x = center.x + radius * cos(angle);
        fcflower.center.y = center.y + radius * sin(angle);
        
        fcflower.draw();
        
        radius = oldRadius;
        angle += 2 * M_PI / numElements;
    }
//    center.y += radius * 11;
}

void flowerCircle::ABreset(ofxOscSender sender){
    if (fcflower.fspiral.a > stopA || fcflower.fspiral.b > stopB){
        fcflower.fspiral.a = startA;
        fcflower.fspiral.b = startB;
        
        if (fcflower.fspiral.stepLength > 17){
            ofxOscMessage unstable;
            unstable.setAddress("/blip");
            unstable.addBoolArg(true);
            sender.sendMessage(unstable);
        }
    }
}

// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void flowerTri::draw() {
    for (int i = 0; i < numElements ; ++i){
        fcflower.center.x = center.x + radius *pow(cos(angle), 4);
        fcflower.center.y = center.y + radius *pow(sin(angle), 3);
        
        fcflower.draw();
        angle += 2 * M_PI / numElements;
    }
}


// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void flowerPatch::draw() {
    for (int i = 0; i < numElements ; ++i){
        fcflower.center.x = center.x + ofRandom(fcflower.fspiral.stepLength*50);
        fcflower.center.y = center.y + ofRandom(fcflower.fspiral.stepLength*50);

        fcflower.draw();
    }
}

// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void flowerVine::draw() {
    int direction = int(ofRandom(-3, 3));
    ofPushMatrix();
    fcflower.fspiral.pos = ofVec3f(ofRandom(vineDepth, ofGetWidth()/2),ofRandom(vineDepth, ofGetHeight()/2),0);
//    ofTranslate((fcflower.fspiral.pos.x), (fcflower.fspiral.pos.y));
    ofTranslate(ofGetWidth()/2, ofGetHeight()/2);
    int randRotate = ofRandom(360)*ofRandom(-1, 1);
    ofRotateDeg(randRotate);
    
    for (int j = 0 ; j < numElements ; ++j){
        for(int i = 0; i< fcflower.numPetals ; ++i){
            
            fcflower.fspiral.color = ofColor(ofRandom(0, 50), ofRandom(0, 255), ofRandom(0, 50));
            fcflower.fspiral.randomizeColor = false;
            fcflower.fspiral.colorStep += 1 ;
            fcflower.fspiral.pos.x += 3 + direction * ofNoise(ofGetElapsedTimef()*0.5 +30);
            fcflower.fspiral.pos.y += 3 + direction * ofNoise(ofGetElapsedTimef()*0.5 +30);
            
            fcflower.fspiral.draw();

        }
    }
//    ofRotateDeg(-randRotate);
    ofPopMatrix();
}


// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


void geomFlower::draw(){
    ofNoFill();
    
    ofSetColor(ofRandom(128, 255),ofRandom(128, 255),ofRandom(128, 255));
    ofDrawCircle(center.x, center.y, radius);
    
    ofSetColor(ofRandom(128, 255),ofRandom(128, 255),ofRandom(128, 255));
    ofDrawCircle(center.x + separation, center.y + separation, radius);
    
    ofSetColor(ofRandom(128, 255),ofRandom(128, 255),ofRandom(128, 255));
    ofDrawCircle(center.x + separation, center.y - separation, radius);
    
    ofSetColor(ofRandom(128, 255),ofRandom(128, 255),ofRandom(128, 255));
    ofDrawCircle(center.x - separation, center.y + separation, radius);
    
    ofSetColor(ofRandom(128, 255),ofRandom(128, 255),ofRandom(128, 255));
    ofDrawCircle(center.x - separation, center.y - separation, radius);
    
    ofSetColor(ofRandom(128, 255),ofRandom(128, 255),ofRandom(128, 255));
    ofDrawCircle(center.x, center.y + radius, radius);
    
    ofSetColor(ofRandom(128, 255),ofRandom(128, 255),ofRandom(128, 255));
    ofDrawCircle(center.x, center.y - radius, radius);
}
