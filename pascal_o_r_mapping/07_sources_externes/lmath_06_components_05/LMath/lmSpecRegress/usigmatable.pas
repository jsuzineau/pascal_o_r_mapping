unit usigmatable;
{$mode objfpc}{$H+}

interface
uses UTypes;

type
TSigmaArray = array[0..100,0..1] of Float;

const SigmaArray : TSigmaArray =
 ((0,	1),
(0.02,	0.9998), //left column: (x_i - mean)/sigma. right column: corresponding y_i/y(mean)
(0.04,	0.9992), //used for quick and rough estimate of sigma in normal distribution
(0.06,	0.9982),
(0.08,	0.9968),
(0.1,	0.995 ),
(0.12,	0.9928),
(0.14,	0.9902),
(0.16,	0.9873),
(0.18,	0.9839),
(0.2,	0.9802),
(0.22,	0.9761),
(0.24,	0.9716),
(0.26,	0.9668),
(0.28,	0.9616),
(0.3,	0.956 ),
(0.32,	0.9501),
(0.34,	0.9438),
(0.36,	0.9373),
(0.38,	0.9303),
(0.4,	0.9231),
(0.42,	0.9156),
(0.44,	0.9077),
(0.46,	0.8996),
(0.48,	0.8912),
(0.5,	0.8825),
(0.52,	0.8735),
(0.54,	0.8643),
(0.56,	0.8549),
(0.58,	0.8452),
(0.6,	0.8353),
(0.62,	0.8251),
(0.64,	0.8148),
(0.66,	0.8043),
(0.68,	0.7936),
(0.7,	0.7827),
(0.72,	0.7717),
(0.74,	0.7605),
(0.76,	0.7492),
(0.78,	0.7377),
(0.8,	0.7261),
(0.82,	0.7145),
(0.84,	0.7027),
(0.86,	0.6909),
(0.88,	0.679 ),
(0.9,	0.667 ),
(0.92,	0.6549),
(0.94,	0.6429),
(0.96,	0.6308),
(0.98,	0.6187),
(1,	0.6065),
(1.02,	0.5944),
(1.04,	0.5823),
(1.06,	0.5702),
(1.08,	0.5581),
(1.1,	0.5461),
(1.12,	0.5341),
(1.14,	0.5222),
(1.16,	0.5103),
(1.18,	0.4985),
(1.2,	0.4868),
(1.22,	0.4751),
(1.24,	0.4636),
(1.26,	0.4521),
(1.28,	0.4408),
(1.3,	0.4296),
(1.32,	0.4184),
(1.34,	0.4075),
(1.36,	0.3966),
(1.38,	0.3859),
(1.4,	0.3753),
(1.42,	0.3649),
(1.44,	0.3546),
(1.46,	0.3445),
(1.48,	0.3345),
(1.5,	0.3247),
(1.52,	0.315 ),
(1.54,	0.3055),
(1.56,	0.2962),
(1.58,	0.287 ),
(1.6,	0.278 ),
(1.62,	0.2692),
(1.64,	0.2606),
(1.66,	0.2521),
(1.68,	0.2439),
(1.7,	0.2357),
(1.72,	0.2278),
(1.74,	0.2201),
(1.76,	0.2125),
(1.78,	0.2051),
(1.8,	0.1979),
(1.82,	0.1909),
(1.84,	0.184 ),
(1.86,	0.1773),
(1.88,	0.1708),
(1.9,	0.1645),
(1.92,	0.1583),
(1.94,	0.1523),
(1.96,	0.1465),
(1.98,	0.1408),
(2,	0.1353));

implementation

end.
