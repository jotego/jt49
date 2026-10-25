Checks the existing unsigned moving average with an impulse (fifteen samples
of amplitude 15), full-scale DC (239), and half-scale DC (120). The existing
delay line spans fifteen samples while normalization divides by sixteen;
the accumulator-width cleanup preserves that established response.
Run through JTFRAME `simunit.sh --run modules/jt12/jt49/ver/mave`.
