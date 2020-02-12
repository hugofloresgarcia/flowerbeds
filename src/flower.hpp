//
//  flower.hpp
//  flowers
//
//  Created by Hugo Flores Garcia on 1/28/20.
//

#ifndef flower_hpp
#define flower_hpp

#include <stdio.h>
#include "ofMain.h"
#include "ofxOsc.h"

#endif /* flower_hpp */

class spiral{
public:
    spiral(ofVec3f center = ofVec3f(ofGetWidth()/2, ofGetHeight()/2, 0),
           int _niter = 200,
           float _stepLength = 20);
    
    
    int niter; // number of iterations run in the for loop
    float a = 0, b = 0;
    float stepLength; //how big of a step there is between lines
    
    int nColorIter = 2000;
    bool randomizeColor = false;
    
    bool deg = false;
    int lineWidth = 1;
    

    ofVec3f pos, oldPos;
    ofColor color ;
    
    int colorStep = 0;
    bool addNoise = true; //add perlin noise?

    void draw();
    
};



class flower {
public:

    flower(spiral _fspiral = spiral(),
           int _numPetals = 5,
           ofVec3f _center = ofVec3f(ofGetWidth()/2, ofGetHeight()/2, 0));
    
    spiral fspiral; //spiral that is drawn in a circular pattern
    int numPetals; //number of "petals"
    ofVec3f center; //center around which it is drawn
    
    void draw();
    

};

class flowerCircle {
public:

    flowerCircle(flower _fcflower = flower(),
                 float _radius = 100,
                 ofVec3f _center = ofVec3f(ofGetHeight()/2,ofGetWidth()/2,0),
                 int _numElements = 12);
    
    float radius; //radius of flower circle
    int numElements; //number of elements in cicle
    
    flower fcflower; //flower that will be drawn
    
    double angle; //should be initialized to zero
    
    ofVec3f center; //center for circle
    
    //swirling
    bool swirl = true;
    float swirlSpeed = 0.5;
    float swirlDepth;
    

    
    void draw();
    
    double startA;
    double startB;
    double stopA;
    double stopB;
    
    void ABreset(ofxOscSender sender);
};

class flowerTri : public flowerCircle {
public:
    void draw();
    
};

class flowerPatch : public flowerCircle {
public:
    int numElements = 5;
    void draw();
};

class flowerVine : public flowerCircle {
public:
    int numElements = 20;
    void draw();
    
    int vineDepth = 80;
};


class flowergeom : public flowerCircle {
    void draw();
};

class geomFlower {
    int radius = 80;
    ofVec3f center = ofVec3f(ofGetWidth()/2, ofGetHeight()/2, 0);
    int separation = 56/80 * radius;
    
    geomFlower(int radius = 80,
               ofVec3f center = ofVec3f(ofGetWidth()/2, ofGetHeight()/2, 0),
               int separation = 56);
    
    void draw();
};
