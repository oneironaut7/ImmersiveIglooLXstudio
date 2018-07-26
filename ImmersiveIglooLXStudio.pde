/** 
 * By using LX Studio, you agree to the terms of the LX Studio Software
 * License and Distribution Agreement, available at: http://lx.studio/license
 *
 * Please note that the LX license is not open-source. The license
 * allows for free, non-commercial use.
 *
 * HERON ARTS MAKES NO WARRANTY, EXPRESS, IMPLIED, STATUTORY, OR
 * OTHERWISE, AND SPECIFICALLY DISCLAIMS ANY WARRANTY OF
 * MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR A PARTICULAR
 * PURPOSE, WITH RESPECT TO THE SOFTWARE.
 */

// ---------------------------------------------------------------------------
//
// Welcome to LX Studio! Getting started is easy...
// 
// (1) Quickly scan this file
// (2) Look at "Model" to define your model
// (3) Move on to "Patterns" to write your animations
// 
// ---------------------------------------------------------------------------

// Reference to top-level LX instance
heronarts.lx.studio.LXStudio lx;
Envelop envelop;
GridModel3D venue;

void setup() {
  long setupStart = System.nanoTime();
  // Processing setup, constructs the window and the LX instance
  size(800, 720, P3D);
  lx = new heronarts.lx.studio.LXStudio(this, buildModel(), MULTITHREADED);
  lx.ui.setResizable(RESIZABLE);
  //venue = getModel();
  //try {
   // lx = new LXStudio(this, venue);
  //} catch (Exception x) {
   // x.printStackTrace();
    //throw x;
   // }
  
  long setupFinish = System.nanoTime();
  println("Total initialization time: " + ((setupFinish - setupStart) / 1000000) + "ms"); 
}

void initialize(final heronarts.lx.studio.LXStudio lx, heronarts.lx.studio.LXStudio.UI ui) {
  // Add custom components or output drivers here
  lx.engine.addOutput(new FadecandyOutput(lx, "localhost", 7890, lx.model));
  envelop = new Envelop(lx);
  lx.engine.registerComponent("envelop", envelop);
  lx.engine.addLoopTask(envelop);
  
  // Missing many components needed to receive OSC signals cleanly from Ableton
  /*
  // Output drivers
  try {
    lx.engine.output.gammaCorrection.setValue(1);
    lx.engine.output.enabled.setValue(false);
   // lx.addOutput(getOutput(lx));
  } catch (Exception x) {
    throw new RuntimeException(x);
  }
   */ 
  // OSC drivers
 //try {
   // lx.engine.osc.receiver(3344).addListener(new EnvelopOscControlListener(lx));
   // lx.engine.osc.receiver(3355).addListener(new EnvelopOscSourceListener());
  //  lx.engine.osc.receiver(3366).addListener(new EnvelopOscMeterListener());
   // adding this breaks the EnvelopOSCListener tab with a NullPointerException probably because I didn't add all the code 
   // lx.engine.osc.receiver(3377).addListener(new EnvelopOscListener());
 // }  catch (SocketException sx) {
  //  throw new RuntimeException(sx);
  //}

  ui.theme.setPrimaryColor(#008ba0);
  ui.theme.setSecondaryColor(#00a08b);
  ui.theme.setAttentionColor(#a00044);
  ui.theme.setFocusColor(#0094aa);
  ui.theme.setSurfaceColor(#cc3300);
  
  
}

void onUIReady(heronarts.lx.studio.LXStudio lx, heronarts.lx.studio.LXStudio.UI ui) {
  //hides the Audio pane on e top left side bar 
  //ui.leftPane.audio.setVisible(false);
  //ui.preview.addComponent(getUIVenue());  
  ui.preview.addComponent(new UISoundObjects());
  //ui.preview.setPhi(PI/32).setMinRadius(2*FEET).setMaxRadius(48*FEET);
  new UIEnvelopSource(ui, ui.leftPane.global.getContentWidth()).addToContainer(ui.leftPane.global, 2);
  new UIEnvelopDecode(ui, ui.leftPane.global.getContentWidth()).addToContainer(ui.leftPane.global, 3);

}

void draw() {
  // All is handled by LX Studio
}

// Configuration flags
final static boolean MULTITHREADED = true;
final static boolean RESIZABLE = true;

// Helpful global constants
final static float INCHES = 1;
final static float IN = INCHES;
final static float FEET = 12 * INCHES;
final static float FT = FEET;
final static float CM = IN / 2.54;
final static float MM = CM * .1;
final static float M = CM * 100;
final static float METER = M;

static class Envelop extends LXRunnableComponent {
  
  public final Source source = new Source();
  public final Decode decode = new Decode();
  
  public Envelop(LX lx) {
    super(lx, "Envelop");
    addSubcomponent(source);
    addSubcomponent(decode);
    source.start();
    decode.start();
    start();
  }
  
  @Override
  public void run(double deltaMs) {
    source.loop(deltaMs);
    decode.loop(deltaMs);
  }
  
  private final static String KEY_SOURCE = "source";
  private final static String KEY_DECODE = "decode";
  
  @Override
  public void save(LX lx, JsonObject obj) {
    super.save(lx, obj);
    obj.add(KEY_SOURCE, LXSerializable.Utils.toObject(lx, this.source));
    obj.add(KEY_DECODE, LXSerializable.Utils.toObject(lx, this.decode));
  }
  
  @Override
  public void load(LX lx, JsonObject obj) {
    if (obj.has(KEY_SOURCE)) {
      this.source.load(lx, obj.getAsJsonObject(KEY_SOURCE));
    }
    if (obj.has(KEY_DECODE)) {
      this.decode.load(lx, obj.getAsJsonObject(KEY_DECODE));
    }
    super.load(lx, obj);
  }
  
  abstract class Meter extends LXRunnableComponent {

    private static final double TIMEOUT = 1000;
    
    private final double[] targets;
    private final double[] timeouts;
    
    public final BoundedParameter gain = (BoundedParameter)
      new BoundedParameter("Gain", 0, -24, 24)
      .setDescription("Sets the dB gain of the meter")
      .setUnits(LXParameter.Units.DECIBELS);
    
    public final BoundedParameter range = (BoundedParameter)
      new BoundedParameter("Range", 24, 6, 96)
      .setDescription("Sets the dB range of the meter")
      .setUnits(LXParameter.Units.DECIBELS);
      
    public final BoundedParameter attack = (BoundedParameter)
      new BoundedParameter("Attack", 25, 0, 50)
      .setDescription("Sets the attack time of the meter response")
      .setUnits(LXParameter.Units.MILLISECONDS);
      
    public final BoundedParameter release = (BoundedParameter)
      new BoundedParameter("Release", 50, 0, 500)
      .setDescription("Sets the release time of the meter response")
      .setUnits(LXParameter.Units.MILLISECONDS);
    
    protected Meter(String label, int numChannels) {
      super(label);
      this.targets = new double[numChannels];
      this.timeouts = new double[numChannels];
      addParameter(this.gain);
      addParameter(this.range);
      addParameter(this.attack);
      addParameter(this.release);
    }
    
    public void run(double deltaMs) {
      NormalizedParameter[] channels = getChannels();
      for (int i = 0; i < channels.length; ++i) {
        this.timeouts[i] += deltaMs;
        if (this.timeouts[i] > TIMEOUT) {
          this.targets[i] = 0;
        }
        double target = this.targets[i];
        double value = channels[i].getValue();
        double gain = (target >= value) ? Math.exp(-deltaMs / attack.getValue()) : Math.exp(-deltaMs / release.getValue());
        channels[i].setValue(target + gain * (value - target));
      }
    }
    
    public void setLevel(int index, OscMessage message) {
      double gainValue = this.gain.getValue();
      double rangeValue = this.range.getValue();
      this.targets[index] = constrain((float) (1 + (message.getFloat() + gainValue) / rangeValue), 0, 1);
      this.timeouts[index] = 0;
    }
    
    public void setLevels(OscMessage message) {
      double gainValue = this.gain.getValue();
      double rangeValue = this.range.getValue();
      for (int i = 0; i < this.targets.length; ++i) {
        this.targets[i] = constrain((float) (1 + (message.getFloat() + gainValue) / rangeValue), 0, 1);
        this.timeouts[i] = 0;
      }
    }
    
    protected abstract NormalizedParameter[] getChannels();
  }
  
  class Source extends Meter {
    public static final int NUM_CHANNELS = 16;
    
    class Channel extends NormalizedParameter {
      
      public final int index;
      public boolean active;
      public final PVector xyz = new PVector();
      
      float tx;
      float ty;
      float tz;
      
      Channel(int i) {
        super("Source-" + (i+1));
        this.index = i+1;
        this.active = false;
      }
    }
    
    public final Channel[] channels = new Channel[NUM_CHANNELS];
    
    Source() {
      super("Source", NUM_CHANNELS);
      for (int i = 0; i < channels.length; ++i) {
        addParameter(channels[i] = new Channel(i));
      }
    }
        
    public NormalizedParameter[] getChannels() {
      return this.channels;
    }
  }
  
  class Decode extends Meter {
    
    public static final int NUM_CHANNELS = 8;
    public final NormalizedParameter[] channels = new NormalizedParameter[NUM_CHANNELS];
    
    Decode() {
      super("Decode", NUM_CHANNELS);
      for (int i = 0; i < channels.length; ++i) {
        addParameter(channels[i] = new NormalizedParameter("Decode-" + (i+1)));
      }
    }
    
    public NormalizedParameter[] getChannels() {
      return this.channels;
    }
  }
}
