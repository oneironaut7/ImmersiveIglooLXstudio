import java.util.Arrays;
import java.util.Collections;
import java.util.List;


LXModel buildModel() {
  // A three-dimensional grid model
  return new GridModel3D();
}

public static class GridModel3D extends LXModel {
  
  public final static int SIZE = 20;
  
  public GridModel3D() {
    super(new Fixture());
  }
  
  public static class Fixture extends LXAbstractFixture {
    Fixture() {
   
     
    // Each Block side is 1 unit. "h" is the Block height
    //float h = 1.2;
    float w = 0 ; // X offset
    float v = 0; // y offset
    float offset = 0;//2*PI*0.75;
    int LED_64 = 64;
    int LED_50 = 50;
    float r_add = 0.5;
    float dtr = (2*PI)/360; //degrees to radians 
    //int Q1_offset = 0;
    //int Q2_offset = 512;
    //int Q3_offset = 1024;
    //int Q4_offset = 1536;
    float Ring1_radius = 6;
    float Ring2_radius = 5;
    float Ring3_radius = 4;
    float Ring4_radius = 3;
    float Ring5_radius = 2;
    float Ring6_radius = 1;
    
    //z coordinates for each ring
    float z_mod = 5.0;
    float Ring1_z = 0.00001;
    float Ring2_z = 2.0;
    float Ring3_z = 3.5;
    float Ring4_z = 4.2;
    float Ring5_z = 4.7;
    float Ring6_z = 5.0;
    
    
    
        
    //cells = new Cell[cell_offset + num_pix];
    //opc.showLocations(false);
    
    //Angles for each strand for FC Board #1
    //Ring1
    float S1l= (310 * dtr) + offset;
    float S1h=(350*dtr) + offset;
    float S2l=(270*dtr) + offset;
    float S2h=(310*dtr) + offset;
    float S3l=(230*dtr) + offset;
    float S3h=(270*dtr) + offset;
    float S4l=(190*dtr) + offset;
    float S4h=(230*dtr) + offset;
    //Ring2
    float S5l=(310*dtr) + offset;
    float S5h=(350*dtr) + offset;
    float S6l=(270*dtr) + offset;
    float S6h=(310*dtr) + offset;
    float S7l=(230*dtr) + offset;
    float S7h=(270*dtr) + offset;
    float S8l=(190*dtr) + offset;
    float S8h=(230*dtr) + offset;
    
    //Angles for each strand for FC Board #2
    //Ring3
    float S9l= (-30 * dtr) + offset;
    float S9h=(30*dtr) + offset;
    float S10l=(270*dtr) + offset;
    float S10h=(330*dtr) + offset;
    float S11l=(215*dtr) + offset;
    float S11h=(270*dtr) + offset;
    float S12l=(150*dtr) + offset;
    float S12h=(215*dtr) + offset;
    //Ring4
    float S13l=(-50*dtr) + offset;
    float S13h=(20*dtr) + offset;
    float S14l=(270*dtr) + offset;
    float S14h=(340*dtr) + offset;
    float S15l=(205*dtr) + offset;
    float S15h=(270*dtr) + offset;
    float S16l=(145*dtr) + offset;
    float S16h=(205*dtr) + offset;
    
    
    //Angles for each strand for FC Board #3
    //Strands 17,20 and 24 are empty
    //Ring5
    float S18l= (120 * dtr) + offset;
    float S18h=(270*dtr) + offset;
    //Ring6
    float S19l=(-90*dtr) + offset;
    float S19h=(90*dtr) + offset;
    //Ring5
    float S21l=(30*dtr) + offset;
    float S21h=(120*dtr) + offset;
    float S22l=(-90*dtr) + offset;
    float S22h=(30*dtr) + offset;
    //Ring6
    float S23l=(90*dtr) + offset;
    float S23h=(270*dtr) + offset;
    
    //Angles for each strand for FC Board #4
    //Strands 25, 29 and 32 are empty
    //Ring3
    float S26l= (90 * dtr) + offset;
    float S26h=(150 * dtr) + offset;
    float S27l=(60 * dtr) + offset;
    float S27h=(90 * dtr) + offset;
    float S28l=(30 * dtr) + offset;
    float S28h=(60 * dtr) + offset;
    //Ring4
    float S30l=(90 * dtr) + offset;
    float S30h=(145 * dtr) + offset;
    float S31l=(20 * dtr) + offset;
    float S31h=(90 * dtr) + offset;
    
    //Angles for each strand for FC Board #1
    //Ring1
    float S33l=(130*dtr) + offset;
    float S33h=(170*dtr) + offset;
    float S34l=(90*dtr) + offset;
    float S34h=(130*dtr) + offset;
    float S35l=(50*dtr) + offset;
    float S35h=(90*dtr) + offset;
    float S36l=(10*dtr) + offset;
    float S36h=(50*dtr) + offset;
    //Ring2
    float S37l=(130*dtr) + offset;
    float S37h=(170*dtr) + offset;
    float S38l=(90*dtr) + offset;
    float S38h=(130*dtr) + offset;
    float S39l=(50*dtr) + offset;
    float S39h=(90*dtr) + offset;
    float S40l=(10*dtr) + offset;
    float S40h=(50*dtr) + offset;
    
    
    
    //set pixels for FadeCandy Board # 1
    //Strand 1
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(  w +((Ring1_radius + (r_add)) * sin((((S1h-S1l)/LED_50)*i)+S1l)),Ring1_z,  v +((Ring1_radius+(r_add)) * cos((((S1h-S1l)/LED_50)*i)+S1l))));  
       } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //strand 2
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint( w +((Ring1_radius + (r_add)) * sin((((S2h-S2l)/LED_50)*i)+S2l)),Ring1_z,  v +((Ring1_radius+(r_add)) * cos((((S2h-S2l)/LED_50)*i)+S2l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //Strand 3
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(w +((Ring1_radius + (r_add)) * sin((((S3h-S3l)/LED_50)*(LED_50-i))+S3l)),Ring1_z,  v +((Ring1_radius+(r_add)) * cos((((S3h-S3l)/LED_50)*(LED_50-i))+S3l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
     //Strand 4
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(w +((Ring1_radius + (r_add)) * sin((((S4h-S4l)/LED_50)*(LED_50-i))+S4l)),Ring1_z,  v +((Ring1_radius+(r_add)) * cos((((S4h-S4l)/LED_50)*(LED_50-i))+S4l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
     //Strand 5
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint( w +((Ring2_radius + (r_add)) * sin((((S5h-S5l)/LED_50)*i)+S5l)),Ring2_z,  v +((Ring2_radius+(r_add)) * cos((((S5h-S5l)/LED_50)*i)+S5l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    }
     //Strand 6
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint( w +((Ring2_radius + (r_add)) * sin((((S6h-S6l)/LED_50)*i)+S6l)),Ring2_z,  v +((Ring2_radius+(r_add)) * cos((((S6h-S6l)/LED_50)*i)+S6l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    }
     //Strand 7
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(w +((Ring2_radius + (r_add)) * sin((((S7h-S7l)/LED_50)*(LED_50-i))+S7l)),Ring2_z,  v +((Ring2_radius+(r_add)) * cos((((S7h-S7l)/LED_50)*(LED_50-i))+S7l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //Strand 8
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(w +((Ring2_radius + (r_add)) * sin((((S8h-S8l)/LED_50)*(LED_50-i))+S8l)),Ring2_z,  v +((Ring2_radius+(r_add)) * cos((((S8h-S8l)/LED_50)*(LED_50-i))+S8l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    
     //set pixels FadeCandy Board #2
     //Strand 9
     for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(  w +((Ring3_radius + (r_add)) * sin((((S9h-S9l)/LED_50)*i)+S9l)),Ring3_z,  v +((Ring3_radius+(r_add)) * cos((((S9h-S9l)/LED_50)*i)+S9l))));  
       } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
     //Strand 10
     for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(  w +((Ring3_radius + (r_add)) * sin((((S10h-S10l)/LED_50)*i)+S10l)),Ring3_z,  v +((Ring3_radius+(r_add)) * cos((((S10h-S10l)/LED_50)*i)+S10l))));  
       } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //Strand 11
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(w +((Ring3_radius + (r_add)) * sin((((S11h-S11l)/LED_50)*(LED_50-i))+S11l)),Ring3_z,  v +((Ring3_radius+(r_add)) * cos((((S11h-S11l)/LED_50)*(LED_50-i))+S11l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
     //Strand 12 ******64 LEDs******
     for (int i = 0; i < 64; i++) {
        addPoint(new LXPoint(w +((Ring3_radius + (r_add)) * sin((((S12h-S12l)/LED_64)*(LED_64-i))+S12l)),Ring3_z, v +((Ring3_radius+(r_add)) * cos((((S12h-S12l)/LED_64)*(LED_64-i))+S12l))));      
    } 
    //Strand 13
     for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(  w +((Ring4_radius + (r_add)) * sin((((S13h-S13l)/LED_50)*i)+S13l)),Ring4_z, v +((Ring4_radius+(r_add)) * cos((((S13h-S13l)/LED_50)*i)+S13l))));  
       } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
     //Strand 14
     for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(  w +((Ring4_radius + (r_add)) * sin((((S14h-S14l)/LED_50)*i)+S14l)),Ring4_z, v +((Ring4_radius+(r_add)) * cos((((S14h-S14l)/LED_50)*i)+S14l))));  
       } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //Strand 15
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(w +((Ring4_radius + (r_add)) * sin((((S15h-S15l)/LED_50)*(LED_50-i))+S15l)),Ring4_z, v +((Ring4_radius+(r_add)) * cos((((S15h-S15l)/LED_50)*(LED_50-i))+S15l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //Strand 16
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(w +((Ring4_radius + (r_add)) * sin((((S16h-S16l)/LED_50)*(LED_50-i))+S16l)),Ring4_z, v +((Ring4_radius+(r_add)) * cos((((S16h-S16l)/LED_50)*(LED_50-i))+S16l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    
    //set pixels FadeCandy Board # 3
    //Strand 17
    for (int i = 0; i < 64; i++) {
        addPoint(new LXPoint( w , v ,i*0.0000001));  
    } 
    //Strand 18 ******64 LEDs******
    for (int i = 0; i < 64; i++) {
        addPoint(new LXPoint( w +((Ring5_radius + (r_add)) * sin((((S18h-S18l)/LED_64)*(LED_64-i))+S18l)),Ring5_z, v +((Ring5_radius+(r_add)) * cos((((S18h-S18l)/LED_64)*(LED_64-i))+S18l))));  
    } 
    //Strand 19
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(w +((Ring6_radius + (r_add)) * sin((((S19h-S19l)/LED_50)*i)+S19l)),Ring6_z, v +((Ring6_radius+(r_add)) * cos((((S19h-S19l)/LED_50)*i)+S19l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //Strand 20 
    for (int i = 0; i < 64; i++) {
        addPoint(new LXPoint( w , v ,i*0.0000001));  
    } 
    //Strand 21 ******64 LEDs******
    for (int i = 0; i < 64; i++) {
        addPoint(new LXPoint( w +((Ring5_radius + (r_add)) * sin((((S21h-S21l)/LED_64)*i)+S21l)),Ring5_z, v +((Ring5_radius+(r_add)) * cos((((S21h-S21l)/LED_64)*i)+S21l))));  
    } 
    //Strand 22 ******64 LEDs******
    for (int i = 0; i < 64; i++) {
        addPoint(new LXPoint( w +((Ring5_radius + (r_add)) * sin((((S22h-S22l)/LED_64)*i)+S22l)),Ring5_z,  v +((Ring5_radius+(r_add)) * cos((((S22h-S22l)/LED_64)*i)+S22l))));  
    } 
     //Strand 23
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(w +((Ring6_radius + (r_add)) * sin((((S23h-S23l)/LED_50)*(LED_50-i))+S23l)),Ring6_z,  v +((Ring6_radius+(r_add)) * cos((((S23h-S23l)/LED_50)*(LED_50-i))+S23l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
     //Strand 24
    for (int i = 0; i < 64; i++) {
        addPoint(new LXPoint( w , v ,i*0.0000001));  
    } 
    
    //set pixels FadeCandy Board # 4
    //Strand 25
    for (int i = 0; i < 64; i++) {
        addPoint(new LXPoint( w , v ,i*0.0000001));  
    } 
    //Strand 26 ******64 LEDs******
    for (int i = 0; i < 64; i++) {
        addPoint(new LXPoint( w +((Ring3_radius + (r_add)) * sin((((S26h-S26l)/LED_64)*i)+S26l)),Ring3_z, v +((Ring3_radius+(r_add)) * cos((((S26h-S26l)/LED_64)*i)+S26l))));  
    } 
    //Strand 27
    for (int i = 0; i < 64; i++) {
        if (i < 50){  
        addPoint(new LXPoint( w +((Ring3_radius + (r_add)) * sin((((S27h-S27l)/LED_50)*(LED_50-i))+S27l)),Ring3_z,  v +((Ring3_radius+(r_add)) * cos((((S27h-S27l)/LED_50)*(LED_50-i))+S27l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }  
    } 
    //Strand 28 ******64 LEDs******
    for (int i = 0; i < 64; i++) {
        //if (i < 50){  
        addPoint(new LXPoint( w +((Ring3_radius + (r_add)) * sin((((S28h-S28l)/LED_64)*(LED_64-i))+S28l)),Ring3_z, v +((Ring3_radius+(r_add)) * cos((((S28h-S28l)/LED_64)*(LED_64-i))+S28l))));  
        //} else {
        //addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        //}  
    } 
    //Strand 29
    for (int i = 0; i < 64; i++) {
        addPoint(new LXPoint( w , v ,i*0.0000001));  
    } 
    //Strand 30
    for (int i = 0; i < 64; i++) {
        if (i < 50){  
        addPoint(new LXPoint( w +((Ring4_radius + (r_add)) * sin((((S30h-S30l)/LED_50)*i)+S30l)),Ring4_z, v +((Ring4_radius+(r_add)) * cos((((S30h-S30l)/LED_50)*i)+S30l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }  
    } 
    //Strand 31
    for (int i = 0; i < 64; i++) {
        if (i < 50){  
        addPoint(new LXPoint( w +((Ring4_radius + (r_add)) * sin((((S31h-S31l)/LED_50)*(LED_50-i))+S31l)),Ring4_z, v +((Ring4_radius+(r_add)) * cos((((S31h-S31l)/LED_50)*(LED_50-i))+S31l))));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }  
    } 
    //Strand 32
    for (int i = 0; i < 64; i++) {
        addPoint(new LXPoint( w , v ,i*0.0000001));  
    }
    
    //set pixels Quadrant 5 FadeCandy Board # 5
    //Strand 33
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(  w +((Ring1_radius + (r_add)) * sin((((S33h-S33l)/LED_50)*i)+S33l)),Ring1_z, v +((Ring1_radius+(r_add)) * cos((((S33h-S33l)/LED_50)*i)+S33l))));  
       } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //Strand 34
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(  w +((Ring1_radius + (r_add)) * sin((((S34h-S34l)/LED_50)*i)+S34l)),Ring1_z, v +((Ring1_radius+(r_add)) * cos((((S34h-S34l)/LED_50)*i)+S34l))));  
       } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //Strand 35
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(  w +((Ring1_radius + (r_add)) * sin((((S35h-S35l)/LED_50)*(LED_50-i))+S35l)),Ring1_z, v +((Ring1_radius+(r_add)) * cos((((S35h-S35l)/LED_50)*(LED_50-i))+S35l))));  
       } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //Strand 36
     for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(  w +((Ring1_radius + (r_add)) * sin((((S36h-S36l)/LED_50)*(LED_50-i))+S36l)),Ring1_z, v +((Ring1_radius+(r_add)) * cos((((S36h-S36l)/LED_50)*(LED_50-i))+S36l))));  
       } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //Strand 37
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(  w +((Ring2_radius + (r_add)) * sin((((S37h-S37l)/LED_50)*i)+S37l)),Ring2_z, v +((Ring2_radius+(r_add)) * cos((((S37h-S37l)/LED_50)*i)+S37l))));  
       } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //Strand 38
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(  w +((Ring2_radius + (r_add)) * sin((((S38h-S38l)/LED_50)*i)+S38l)),Ring2_z, v +((Ring2_radius+(r_add)) * cos((((S38h-S38l)/LED_50)*i)+S38l))));  
       } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //Strand 39
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(  w +((Ring2_radius + (r_add)) * sin((((S39h-S39l)/LED_50)*(LED_50-i))+S39l)),Ring2_z, v +((Ring2_radius+(r_add)) * cos((((S39h-S39l)/LED_50)*(LED_50-i))+S39l))));  
       } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    }
    //Strand 40
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(  w +((Ring2_radius + (r_add)) * sin((((S40h-S40l)/LED_50)*(LED_50-i))+S40l)),Ring2_z, v +((Ring2_radius+(r_add)) * cos((((S40h-S40l)/LED_50)*(LED_50-i))+S40l))));  
       } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    /*
    //strand 2
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint( w +((Ring1_radius + (r_add)) * sin((((S2h-S2l)/LED_50)*i)+S2l)),  v +((Ring1_radius+(r_add)) * cos((((S2h-S2l)/LED_50)*i)+S2l)),i*0.0000001));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //Strand 3
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(w +((Ring1_radius + (r_add)) * sin((((S3h-S3l)/LED_50)*(LED_50-i))+S3l)),  v +((Ring1_radius+(r_add)) * cos((((S3h-S3l)/LED_50)*(LED_50-i))+S3l)),i*0.0000001));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
     //Strand 4
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(w +((Ring1_radius + (r_add)) * sin((((S4h-S4l)/LED_50)*(LED_50-i))+S4l)),  v +((Ring1_radius+(r_add)) * cos((((S4h-S4l)/LED_50)*(LED_50-i))+S4l)),i*0.0000001));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
     //Strand 5
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint( w +((Ring2_radius + (r_add)) * sin((((S5h-S5l)/LED_50)*i)+S5l)),  v +((Ring2_radius+(r_add)) * cos((((S5h-S5l)/LED_50)*i)+S5l)),i*0.0000001));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    }
     //Strand 6
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint( w +((Ring2_radius + (r_add)) * sin((((S6h-S6l)/LED_50)*i)+S6l)),  v +((Ring2_radius+(r_add)) * cos((((S6h-S6l)/LED_50)*i)+S6l)),i*0.0000001));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    }
     //Strand 7
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(w +((Ring2_radius + (r_add)) * sin((((S7h-S7l)/LED_50)*(LED_50-i))+S7l)),  v +((Ring2_radius+(r_add)) * cos((((S7h-S7l)/LED_50)*(LED_50-i))+S7l)),i*0.0000001));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } 
    //Strand 8
    for (int i = 0; i < 64; i++) {
        if (i < 50){
        addPoint(new LXPoint(w +((Ring2_radius + (r_add)) * sin((((S8h-S8l)/LED_50)*(LED_50-i))+S8l)),  v +((Ring2_radius+(r_add)) * cos((((S8h-S8l)/LED_50)*(LED_50-i))+S8l)),i*0.0000001));  
        } else {
        addPoint(new LXPoint(  w ,  v ,i*0.0000001));
        }
    } */
    /*
    for (int i = 0; i<arraySize; ++i){
      addPoint(new LXPoint( radius1 * sin(((i)/float(arraySize))*2*PI),  radius1 * cos(((i)/float(arraySize))*2*PI),i*0.0000001));
       }
    for (int i = 0; i<arraySize; ++i){
      addPoint(new LXPoint( radius2 * sin(((i)/float(arraySize))*2*PI),  radius2 * cos(((i)/float(arraySize))*2*PI),i*0.0000001));
      }   
    for (int i = 0; i<arraySize; ++i){
      addPoint(new LXPoint( radius3 * sin(((i)/float(arraySize))*2*PI),  radius3 * cos(((i)/float(arraySize))*2*PI),i*0.0000001));
       }
    for (int i = 0; i<arraySize; ++i){
      addPoint(new LXPoint( radius4 * sin(((i)/float(arraySize))*2*PI),  radius4 * cos(((i)/float(arraySize))*2*PI),i*0.0000001));
      } 
     for (int i = 0; i<arraySize; ++i){
      addPoint(new LXPoint( radius5 * sin(((i)/float(arraySize))*2*PI),  radius5 * cos(((i)/float(arraySize))*2*PI),i*0.0000001));
       }
    for (int i = 0; i<arraySize; ++i){
      addPoint(new LXPoint( radius6 * sin(((i)/float(arraySize))*2*PI),  radius6 * cos(((i)/float(arraySize))*2*PI),i*0.0000001));
      }   
    for (int i = 0; i<arraySize; ++i){
      addPoint(new LXPoint( radius7 * sin(((i)/float(arraySize))*2*PI),  radius7 * cos(((i)/float(arraySize))*2*PI),i*0.0000001));
       }
    for (int i = 0; i<arraySize; ++i){
      addPoint(new LXPoint( radius8 * sin(((i)/float(arraySize))*2*PI),  radius8 * cos(((i)/float(arraySize))*2*PI),i*0.0000001));
      }  
      */
     /* int mult = 5;
      for (int z = 0; z < SIZE; ++z) {
        for (int y = 0; y < SIZE; ++y) {
          for (int x = 0; x < SIZE; ++x) {
            addPoint(new LXPoint((x*mult), (y*mult), (z*mult)));
          }
        }
      }*/
    }
  }
}
