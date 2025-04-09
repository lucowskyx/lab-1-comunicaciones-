
% Código 1: Parámetros y auxiliares
tm = 1e-5;
t = 0:tm:0.05;
f = 1000;
mt = sin(2*pi*f*t);

fs = 10000;
ts = 1/fs;
tau = ts/2;
d = tau/ts;

R = round(ts/tm);
S = round(tau/tm);

% Código 2: Muestreo natural
snat = zeros(size(t));
for i = 1:R:length(t)-S
    snat(i:i+S-1) = 1;
end
mtnat = mt .* snat;

% Código 3: Muestreo instantáneo
mtinst = zeros(size(t));
for i = 1:R:length(t)-S
    mtinst(i:i+S-1) = mt(i);
end

% Código 4: Transformadas de Fourier
Mt = abs(fft(mt));
Mtnat = abs(fft(mtnat));
Mtinst = abs(fft(mtinst));

N = length(mt);
fvec = linspace(0, fs, N);

fvec_half = fvec(1:N/2);
Mt_half = Mt(1:N/2);
Mtnat_half = Mtnat(1:N/2);
Mtinst_half = Mtinst(1:N/2);

% Código 5: PCM y cuantización
N = 64;
pcm_levels = 2^log2(N);

signal_shifted = mtinst + 1;
signal_scaled = signal_shifted * (pcm_levels - 1);
signal_scaled = signal_scaled / 2;

pcm_signal_inst = round(signal_scaled);

% Código 6: Error de cuantización
reconstructed = (2 * pcm_signal_inst / (pcm_levels - 1)) - 1;
quantization_error_inst = mtinst - reconstructed;
