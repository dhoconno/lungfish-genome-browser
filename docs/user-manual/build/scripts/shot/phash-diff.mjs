import sharp from "sharp";

export async function phash(path) {
  const { data } = await sharp(path)
    .greyscale()
    .resize(32, 32, { fit: "fill" })
    .raw()
    .toBuffer({ resolveWithObject: true });

  // Naive 32x32 DCT-II (row + column)
  const N = 32;
  const pixels = new Float64Array(N * N);
  for (let i = 0; i < pixels.length; i++) pixels[i] = data[i];

  const dct = dct2d(pixels, N);

  // Take top-left 8x8, excluding DC (first coefficient)
  const coeffs = [];
  for (let y = 0; y < 8; y++) {
    for (let x = 0; x < 8; x++) {
      if (x === 0 && y === 0) continue;
      coeffs.push(dct[y * N + x]);
    }
  }
  const median = [...coeffs].sort((a, b) => a - b)[Math.floor(coeffs.length / 2)];
  let hash = 0n;
  for (let i = 0; i < 63; i++) {
    if (coeffs[i] > median) hash |= 1n << BigInt(i);
  }
  return hash;
}

export async function phashDistance(pathA, pathB) {
  const [a, b] = await Promise.all([phash(pathA), phash(pathB)]);
  let x = a ^ b, d = 0;
  while (x !== 0n) { d += Number(x & 1n); x >>= 1n; }
  return d;
}

function dct2d(src, N) {
  const rowOut = new Float64Array(N * N);
  const out = new Float64Array(N * N);

  // Row DCT
  for (let y = 0; y < N; y++) {
    for (let u = 0; u < N; u++) {
      let sum = 0;
      for (let x = 0; x < N; x++) {
        sum += src[y * N + x] * Math.cos(((2 * x + 1) * u * Math.PI) / (2 * N));
      }
      const alpha = u === 0 ? 1 / Math.sqrt(N) : Math.sqrt(2 / N);
      rowOut[y * N + u] = alpha * sum;
    }
  }

  // Column DCT
  for (let u = 0; u < N; u++) {
    for (let v = 0; v < N; v++) {
      let sum = 0;
      for (let y = 0; y < N; y++) {
        sum += rowOut[y * N + u] * Math.cos(((2 * y + 1) * v * Math.PI) / (2 * N));
      }
      const alpha = v === 0 ? 1 / Math.sqrt(N) : Math.sqrt(2 / N);
      out[v * N + u] = alpha * sum;
    }
  }
  return out;
}
