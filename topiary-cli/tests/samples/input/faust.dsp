//--------------------------------`(si.)smoothq`-------------------------------------
// Smoothing with continuously variable curves from Exponential to Linear, with a constant time.
//
// #### Usage
//
// ```
// _ : smoothq(time, q) : _;
// ```
//
// Where:
//
// * `time`: seconds to reach target
// * `q`: curve shape (between 0..1, 0 is Exponential, 1 is Linear)
//-----------------------------------------------------------------------------
declare smoothq author "Andrew John March";
declare smoothq licence "STK-4.3";

smoothq(time, q, tar) = envelope
  with {
    ratio = pow(q, 5) * 32 : max(0.001);
    coef = (ratio / (1 + ratio))^(1 / (ma.SR * time));
    fb(cBase, cTar, cSrc, cDistance, cDir, cY, cOut) = base, tar, src, distance, dir, y, out
      with {
        trig = cTar != tar;
        src = select2(trig, cSrc, cOut);
        dir = select2(trig, cDir, tar > src);
                base = select2(trig, cBase, select2(dir,
                    (0.0 - ratio) * (1.0 - coef),
                    (1.0 + ratio) * (1.0 - coef)
                ));
                distance = select2(trig, cDistance, abs(tar - src));
                y = select2(dir,
                    select2(trig,
                        max( 0, base + cY * coef),
                        1
                    ),
                    select2(trig,
                        min( 1, base + cY * coef),
                        0
                    )
                );
                out = select2(dir,
                    tar + y * distance,
                    src + y * distance
                );
            };
        envelope = fb ~ (_,_,_,_,_,_,_) : !,!,!,!,!,!,_;
    };
