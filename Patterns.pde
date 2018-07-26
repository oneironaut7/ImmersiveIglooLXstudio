import heronarts.lx.modulator.*;
import java.util.Stack;

public static abstract class EnvelopPattern extends LXModelPattern<GridModel3D> {

  protected EnvelopPattern(LX lx) {
    super(lx);
  }
}

public static class Test extends LXPattern {

  final CompoundParameter thing = new CompoundParameter("Thing", 0, model.yRange);
  final SinLFO lfo = new SinLFO("Stuff", 0, 1, 2000);

  public Test(LX lx) {
    super(lx);
    addParameter(thing);
    startModulator(lfo);
  }

  public void run(double deltaMs) {
    for (LXPoint p : model.points) {
      colors[p.index] = palette.getColor(max(0, 100 - 10*abs(p.y - thing.getValuef())));
    }
  }
}

@LXCategory("Form")
  public class Tron extends LXPattern {

  private final static int MIN_DENSITY = 5;
  private final static int MAX_DENSITY = 80;

  private CompoundParameter period = (CompoundParameter)
    new CompoundParameter("Speed", 150000, 400000, 50000)
    .setExponent(.5)
    .setDescription("Speed of movement");

  private CompoundParameter size = (CompoundParameter)
    new CompoundParameter("Size", 2*FEET, 6*INCHES, 5*FEET)
    .setExponent(2)
    .setDescription("Size of strips");

  private CompoundParameter density = (CompoundParameter)
    new CompoundParameter("Density", 25, MIN_DENSITY, MAX_DENSITY)
    .setDescription("Density of tron strips");

  public Tron(LX lx) {  
    super(lx);
    addParameter("period", this.period);
    addParameter("size", this.size);
    addParameter("density", this.density);    
    for (int i = 0; i < MAX_DENSITY; ++i) {
      addLayer(new Mover(lx, i));
    }
  }

  class Mover extends LXLayer {

    final int index;

    final TriangleLFO pos = new TriangleLFO(0, lx.total, period);

    private final MutableParameter targetBrightness = new MutableParameter(100); 

    private final DampedParameter brightness = new DampedParameter(this.targetBrightness, 50); 

    Mover(LX lx, int index) {
      super(lx);
      this.index = index;
      startModulator(this.brightness);
      startModulator(this.pos.randomBasis());
    }

    public void run(double deltaMs) {
      this.targetBrightness.setValue((density.getValuef() > this.index) ? 100 : 0);
      float maxb = this.brightness.getValuef();
      if (maxb > 0) {
        float pos = this.pos.getValuef();
        float falloff = maxb / size.getValuef();
        for (LXPoint p : model.points) {
          float b = maxb - falloff * LXUtils.wrapdistf(p.index, pos, model.points.length);
          if (b > 0) {
            addColor(p.index, LXColor.gray(b));
          }
        }
      }
    }
  }

  public void run(double deltaMs) {
    setColors(#000000);
  }
}

@LXCategory("Texture")
  public class Noise extends LXPattern {

  public final CompoundParameter scale =
    new CompoundParameter("Scale", 10, 5, 40);

  private final LXParameter scaleDamped =
    startModulator(new DampedParameter(this.scale, 5, 10)); 

  public final CompoundParameter floor =
    new CompoundParameter("Floor", 0, -2, 2)
    .setDescription("Lower bound of the noise");

  private final LXParameter floorDamped =
    startModulator(new DampedParameter(this.floor, .5, 2));    

  public final CompoundParameter range =
    new CompoundParameter("Range", 1, .2, 4)
    .setDescription("Range of the noise");

  private final LXParameter rangeDamped =
    startModulator(new DampedParameter(this.range, .5, 4));

  public final CompoundParameter xSpeed = (CompoundParameter)
    new CompoundParameter("XSpd", 0, -6, 6)
    .setDescription("Rate of motion on the X-axis")
    .setPolarity(LXParameter.Polarity.BIPOLAR);

  public final CompoundParameter ySpeed = (CompoundParameter)
    new CompoundParameter("YSpd", 0, -6, 6)
    .setDescription("Rate of motion on the Y-axis")
    .setPolarity(LXParameter.Polarity.BIPOLAR);

  public final CompoundParameter zSpeed = (CompoundParameter)
    new CompoundParameter("ZSpd", 1, -6, 6)
    .setDescription("Rate of motion on the Z-axis")
    .setPolarity(LXParameter.Polarity.BIPOLAR);

  public final CompoundParameter xOffset = (CompoundParameter)
    new CompoundParameter("XOffs", 0, -1, 1)
    .setDescription("Offset of symmetry on the X-axis")
    .setPolarity(LXParameter.Polarity.BIPOLAR);

  public final CompoundParameter yOffset = (CompoundParameter)
    new CompoundParameter("YOffs", 0, -1, 1)
    .setDescription("Offset of symmetry on the Y-axis")
    .setPolarity(LXParameter.Polarity.BIPOLAR);

  public final CompoundParameter zOffset = (CompoundParameter)
    new CompoundParameter("ZOffs", 0, -1, 1)
    .setDescription("Offset of symmetry on the Z-axis")
    .setPolarity(LXParameter.Polarity.BIPOLAR);

  public Noise(LX lx) {
    super(lx);
    addParameter("scale", this.scale);
    addParameter("floor", this.floor);
    addParameter("range", this.range);
    addParameter("xSpeed", this.xSpeed);
    addParameter("ySpeed", this.ySpeed);
    addParameter("zSpeed", this.zSpeed);
    addParameter("xOffset", this.xOffset);
    addParameter("yOffset", this.yOffset);
    addParameter("zOffset", this.zOffset);
  }

  private class Accum {
    private float accum = 0;
    private int equalCount = 0;

    void accum(double deltaMs, float speed) {
      if (speed != 0) {
        float newAccum = (float) (this.accum + deltaMs * speed * 0.00025);
        if (newAccum == this.accum) {
          if (++this.equalCount >= 5) {
            this.equalCount = 0;
            newAccum = 0;
          }
        }
        this.accum = newAccum;
      }
    }
  };

  private final Accum xAccum = new Accum();
  private final Accum yAccum = new Accum();
  private final Accum zAccum = new Accum();

  @Override
    public void run(double deltaMs) {
    xAccum.accum(deltaMs, xSpeed.getValuef());
    yAccum.accum(deltaMs, ySpeed.getValuef());
    zAccum.accum(deltaMs, zSpeed.getValuef());

    float sf = scaleDamped.getValuef() / 1000.;
    float rf = rangeDamped.getValuef();
    float ff = floorDamped.getValuef();
    float xo = xOffset.getValuef();
    float yo = yOffset.getValuef();
    float zo = zOffset.getValuef();
    for (LXPoint p : model.points) {
      float b = ff + rf * noise(sf*p.x + xo - xAccum.accum, sf*p.y + yo - yAccum.accum, sf*p.z + zo - zAccum.accum);
      colors[p.index] = LXColor.gray(constrain(b*100, 0, 100));
    }
  }
}

//Sets the group to be located in
@LXCategory("Form")
  // Defines the pattern
  public static class Rings extends EnvelopPattern {
  //sets the knob; the variables are defined as (default, min, max)
  //leaving out the min and max defaults to 0 to 1 range
  public final CompoundParameter amplitude =
    new CompoundParameter("Rotation", 0);

  //knob for rotational speed  
  public final CompoundParameter ROTspeed = (CompoundParameter)
    new CompoundParameter("RSpeed", 10000, 20000, 1000)
    .setExponent(.25);

  //Knob for Y speed  
  public final CompoundParameter Yspeed = (CompoundParameter)
    new CompoundParameter("YSpeed", 10000, 40000, 1000)
    .setExponent(.25);  

  public final CompoundParameter thickness =
    new CompoundParameter("Thickness", 40, 10, 100);  

  //defines number of rings; the original stated 2 but 1 looks better for this
  public Rings(LX lx) {
    super(lx);
    for (int i = 0; i < 1; ++i) {
      addLayer(new Ring(lx));
    }
    addParameter("Rotation", this.amplitude);
    addParameter("ROT speed", this.ROTspeed);
    addParameter("Y speed", this.Yspeed);
    addParameter("Thickness", this.thickness);
  }

  //sets color which is white
  public void run(double deltaMs) {
    setColors(#000000);
  }

  //defines the class Ring which is what is added to Rings in the above code
  class Ring extends LXLayer {

    private LXProjection proj = new LXProjection(model);
    // y rotation SawLFO(start value, endvalue, period)
    private final SawLFO yRot = new SawLFO(0, TWO_PI, 9000 + 2000 * Math.random());
    // z rotation SinLFO(start value, endvalue, period)
    private final SinLFO zRot = new SinLFO(-1, 1, ROTspeed);
    // z amplitude
    //private final SinLFO zAmp = new SinLFO(0.5, .5, 13000 + 3000 * Math.random());
    private final SinLFO zAmp = new SinLFO(PI / 10, PI/4, 13000 + 3000 * Math.random());
    //y offset
    //private final SinLFO yOffset = new SinLFO(-2*FEET, 2*FEET, 12000 + 5000*Math.random());
    private final SinLFO yOffset = new SinLFO(-5, 5, Yspeed);

    public Ring(LX lx) {
      super(lx);
      startModulator(yRot.randomBasis());
      startModulator(zRot.randomBasis());
      startModulator(zAmp.randomBasis());
      startModulator(yOffset.randomBasis());
    }

    public void run(double deltaMs) {
      proj.reset().center().rotateY(yRot.getValuef()).rotateZ(amplitude.getValuef() * zAmp.getValuef() * zRot.getValuef());
      float yOffset = this.yOffset.getValuef();
      float falloff = thickness.getValuef();//40; //100 / (2*FEET);
      for (LXVector v : proj) {
        float b = 100 - falloff * abs(v.y - yOffset);  
        if (b > 0) {
          addColor(v.index, LXColor.gray(b));
        }
      }
    }
  }
}

@LXCategory("Form")
  // Defines the pattern
  public static class SawRings extends EnvelopPattern {
  //sets the knob; the variables are defined as (default, min, max)
  //leaving out the min and max defaults to 0 to 1 range
  public final CompoundParameter amplitude =
    new CompoundParameter("Rotation", 0);

  //knob for rotational speed  
  public final CompoundParameter ROTspeed = (CompoundParameter)
    new CompoundParameter("RSpeed", 10000, 20000, 1000)
    .setExponent(.25);

  //Knob for Y speed  
  public final CompoundParameter Yspeed = (CompoundParameter)
    new CompoundParameter("YSpeed", 10000, 40000, 1000)
    .setExponent(.25);  

  public final CompoundParameter thickness =
    new CompoundParameter("Thickness", 40, 10, 100);  

  public final CompoundParameter SawMin =
    new CompoundParameter("SawMin", -8, -20, 20);    

  public final CompoundParameter SawMax =
    new CompoundParameter("SawMax", 8, -20, 20);  

  //defines number of rings; the original stated 2 but 1 looks better for this
  public SawRings(LX lx) {
    super(lx);
    for (int i = 0; i < 1; ++i) {
      addLayer(new Ring(lx));
    }
    addParameter("Rotation", this.amplitude);
    addParameter("ROT speed", this.ROTspeed);
    addParameter("Y speed", this.Yspeed);
    addParameter("Thickness", this.thickness);
    addParameter("SawMin", this.SawMin);
    addParameter("SawMax", this.SawMax);
  }

  //sets color in background Hex #000000 is Black
  public void run(double deltaMs) {
    setColors(#000000);
  }

  //defines the class Ring which is what is added to Rings in the above code
  class Ring extends LXLayer {

    private LXProjection proj = new LXProjection(model);
    // y rotation SawLFO(start value, endvalue, period)
    private final SinLFO yRot = new SinLFO(0, TWO_PI, 9000 + 2000 * Math.random());
    // z rotation SinLFO(start value, endvalue, period)
    private final SinLFO zRot = new SinLFO(-1, 1, ROTspeed);
    // z amplitude
    //private final SinLFO zAmp = new SinLFO(0.5, .5, 13000 + 3000 * Math.random());
    private final SinLFO zAmp = new SinLFO(PI / 10, PI/4, 13000 + 3000 * Math.random());
    //y offset
    //private final SinLFO yOffset = new SinLFO(-2*FEET, 2*FEET, 12000 + 5000*Math.random());
    private final SawLFO yOffset = new SawLFO(SawMin, SawMax, Yspeed);

    public Ring(LX lx) {
      super(lx);
      startModulator(yRot.randomBasis());
      startModulator(zRot.randomBasis());
      startModulator(zAmp.randomBasis());
      startModulator(yOffset.randomBasis());
    }

    public void run(double deltaMs) {
      proj.reset().center().rotateY(yRot.getValuef()).rotateZ(amplitude.getValuef() * zAmp.getValuef() * zRot.getValuef());
      float yOffset = this.yOffset.getValuef();
      float falloff = thickness.getValuef();//40; //100 / (2*FEET);
      for (LXVector v : proj) {
        float b = 100 - falloff * abs(v.y - yOffset);  
        if (b > 0) {
          addColor(v.index, LXColor.gray(b));
        }
      }
    }
  }
}

@LXCategory(LXCategory.TEXTURE)
  public class Sparkle extends LXPattern {

  public final SinLFO[] sparkles = new SinLFO[60]; 
  private final int[] map = new int[model.size];

  public Sparkle(LX lx) {
    super(lx);
    for (int i = 0; i < this.sparkles.length; ++i) {
      this.sparkles[i] = (SinLFO) startModulator(new SinLFO(0, random(50, 120), random(2000, 7000)));
    }
    for (int i = 0; i < model.size; ++i) {
      this.map[i] = (int) constrain(random(0, sparkles.length), 0, sparkles.length-1);
    }
  }

  public void run(double deltaMs) {
    for (LXPoint p : model.points) {
      colors[p.index] = LXColor.gray(constrain(this.sparkles[this.map[p.index]].getValuef(), 0, 100));
    }
  }
}

@LXCategory(LXCategory.TEXTURE)
  public class Starlight extends LXPattern {

  public final CompoundParameter speed = new CompoundParameter("Speed", 1, 2, .5);
  public final CompoundParameter base = new CompoundParameter("Base", -10, -20, 100);

  public final LXModulator[] brt = new LXModulator[50];
  private final int[] map1 = new int[model.size];
  private final int[] map2 = new int[model.size];

  public Starlight(LX lx) {
    super(lx);
    for (int i = 0; i < this.brt.length; ++i) {
      this.brt[i] = startModulator(new SinLFO(this.base, random(50, 120), new FunctionalParameter() {
        private final float rand = random(1000, 5000);
        public double getValue() {
          return rand * speed.getValuef();
        }
      }
      ).randomBasis());
    }
    for (int i = 0; i < model.size; ++i) {
      this.map1[i] = (int) constrain(random(0, this.brt.length), 0, this.brt.length-1);
      this.map2[i] = (int) constrain(random(0, this.brt.length), 0, this.brt.length-1);
    }
    addParameter("speed", this.speed);
    addParameter("base", this.base);
  }

  public void run(double deltaMs) {
    for (LXPoint p : model.points) {
      int i = p.index;
      float brt = this.brt[this.map1[i]].getValuef() + this.brt[this.map2[i]].getValuef(); 
      colors[i] = LXColor.gray(constrain(.5*brt, 0, 100));
    }
  }
}

@LXCategory("MIDI")
  public static class Flash extends LXPattern implements CustomDeviceUI {

  private final BooleanParameter manual =
    new BooleanParameter("Trigger")
    .setMode(BooleanParameter.Mode.MOMENTARY)
    .setDescription("Manually triggers the flash");

  private final BooleanParameter midi =
    new BooleanParameter("MIDI", true)
    .setDescription("Toggles whether the flash is engaged by MIDI note events");

  private final BooleanParameter midiFilter =
    new BooleanParameter("Note Filter")
    .setDescription("Whether to filter specific MIDI note");

  private final DiscreteParameter midiNote = (DiscreteParameter)
    new DiscreteParameter("Note", 0, 128)
    .setUnits(LXParameter.Units.MIDI_NOTE)
    .setDescription("Note to filter for");

  private final CompoundParameter brightness =
    new CompoundParameter("Brt", 100, 0, 100)
    .setDescription("Sets the maxiumum brightness of the flash");

  private final CompoundParameter velocitySensitivity =
    new CompoundParameter("Vel>Brt", .5)
    .setDescription("Sets the amount to which brightness responds to note velocity");

  private final CompoundParameter attack = (CompoundParameter)
    new CompoundParameter("Attack", 50, 25, 1000)
    .setExponent(2)
    .setUnits(LXParameter.Units.MILLISECONDS)
    .setDescription("Sets the attack time of the flash");

  private final CompoundParameter decay = (CompoundParameter)
    new CompoundParameter("Decay", 1000, 50, 10000)
    .setExponent(2)
    .setUnits(LXParameter.Units.MILLISECONDS)
    .setDescription("Sets the decay time of the flash");

  private final CompoundParameter shape = (CompoundParameter)
    new CompoundParameter("Shape", 1, 1, 4)
    .setDescription("Sets the shape of the attack and decay curves");

  private final MutableParameter level = new MutableParameter(0);

  private final ADEnvelope env = new ADEnvelope("Env", 0, level, attack, decay, shape);

  public Flash(LX lx) {
    super(lx);
    addModulator(this.env);
    addParameter("brightness", this.brightness);
    addParameter("attack", this.attack);
    addParameter("decay", this.decay);
    addParameter("shape", this.shape);
    addParameter("velocitySensitivity", this.velocitySensitivity);
    addParameter("manual", this.manual);
    addParameter("midi", this.midi);
    addParameter("midiFilter", this.midiFilter);
    addParameter("midiNote", this.midiNote);
  }

  @Override
    public void onParameterChanged(LXParameter p) {
    if (p == this.manual) {
      if (this.manual.isOn()) {
        level.setValue(brightness.getValue());
      }
      this.env.engage.setValue(this.manual.isOn());
    }
  }

  private boolean isValidNote(MidiNote note) {
    return this.midi.isOn() && (!this.midiFilter.isOn() || (note.getPitch() == this.midiNote.getValuei()));
  }

  @Override
    public void noteOnReceived(MidiNoteOn note) {
    if (isValidNote(note)) {
      level.setValue(brightness.getValue() * lerp(1, note.getVelocity() / 127., velocitySensitivity.getValuef()));
      this.env.engage.setValue(true);
    }
  }

  @Override
    public void noteOffReceived(MidiNote note) {
    if (isValidNote(note)) {
      this.env.engage.setValue(false);
    }
  }

  public void run(double deltaMs) {
    setColors(LXColor.gray(env.getValue()));
  }

  @Override
    public void buildDeviceUI(UI ui, UI2dContainer device) {
    device.setContentWidth(216);
    new UIADWave(ui, 0, 0, device.getContentWidth(), 90).addToContainer(device);

    new UIButton(0, 92, 84, 16).setLabel("Trigger").setParameter(this.manual).setTriggerable(true).addToContainer(device);

    new UIButton(88, 92, 40, 16).setParameter(this.midi).setLabel("Midi").addToContainer(device);

    final UIButton midiFilterButton = (UIButton)
      new UIButton(132, 92, 40, 16)
      .setParameter(this.midiFilter)
      .setLabel("Note")
      .setEnabled(this.midi.isOn())
      .addToContainer(device);

    final UIIntegerBox midiNoteBox = (UIIntegerBox)
      new UIIntegerBox(176, 92, 40, 16)
      .setParameter(this.midiNote)
      .setEnabled(this.midi.isOn() && this.midiFilter.isOn())
      .addToContainer(device);

    new UIKnob(0, 116).setParameter(this.brightness).addToContainer(device);
    new UIKnob(44, 116).setParameter(this.attack).addToContainer(device);
    new UIKnob(88, 116).setParameter(this.decay).addToContainer(device);
    new UIKnob(132, 116).setParameter(this.shape).addToContainer(device);

    final UIKnob velocityKnob = (UIKnob)
      new UIKnob(176, 116)
      .setParameter(this.velocitySensitivity)
      .setEnabled(this.midi.isOn())
      .addToContainer(device);

    this.midi.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter p) {
        velocityKnob.setEnabled(midi.isOn());
        midiFilterButton.setEnabled(midi.isOn());
        midiNoteBox.setEnabled(midi.isOn() && midiFilter.isOn());
      }
    }
    ); 

    this.midiFilter.addListener(new LXParameterListener() {
      public void onParameterChanged(LXParameter p) {
        midiNoteBox.setEnabled(midi.isOn() && midiFilter.isOn());
      }
    }
    );
  }

  class UIADWave extends UI2dComponent {
    UIADWave(UI ui, float x, float y, float w, float h) {
      super(x, y, w, h);
      setBackgroundColor(ui.theme.getDarkBackgroundColor());
      setBorderColor(ui.theme.getControlBorderColor());

      LXParameterListener redraw = new LXParameterListener() {
        public void onParameterChanged(LXParameter p) {
          redraw();
        }
      };

      brightness.addListener(redraw);
      attack.addListener(redraw);
      decay.addListener(redraw);
      shape.addListener(redraw);
    }

    public void onDraw(UI ui, PGraphics pg) {
      double av = attack.getValue();
      double dv = decay.getValue();
      double tv = av + dv;
      double ax = av/tv * (this.width-1);
      double bv = brightness.getValue() / 100.;

      pg.stroke(ui.theme.getPrimaryColor());
      int py = 0;
      for (int x = 1; x < this.width-2; ++x) {
        int y = (x < ax) ?
          (int) Math.round(bv * (height-4.) * Math.pow(((x-1) / ax), shape.getValue())) :
          (int) Math.round(bv * (height-4.) * Math.pow(1 - ((x-ax) / (this.width-1-ax)), shape.getValue()));
        if (x > 1) {
          pg.line(x-1, height-2-py, x, height-2-y);
        }
        py = y;
      }
    }
  }
}
