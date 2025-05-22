PImage dinoImg;        // Imagen del dinosaurio normal
PImage dinoAgachadoImg; // Imagen del dinosaurio agachado
PImage cactusImg;      // Imagen del cactus

// Variables del juego
float dinoY, dinoVel;
boolean saltando = false;
boolean agachado = false;
float[] cactusX = new float[2];
float cactusVel = 1.5;
int Puntos = 0;
boolean gameOver = false;

// Constantes
final int AnchoDino = 15;
final int AlturaDino = 20;
final int AnchoDinoAgachado = 15;
final int AltoDinoAgachado = 10;
final int AnchoCactus = 10;
final int AltoCactus = 20;
final float GRAVEDAD = 0.4;
final float Salto = -8;

void setup() {
  size(128, 160);
  
  // Cargar imágenes (deben estar en la carpeta 'data')
  dinoImg = loadImage("dino.jpg");
  dinoAgachadoImg = loadImage("dino_agachado.jpg");
  cactusImg = loadImage("cactus.jpg"); // Nueva imagen para cactus
  
  // Redimensionar imágenes
  dinoImg.resize(AnchoDino, AlturaDino);
  dinoAgachadoImg.resize(AnchoDinoAgachado, AltoDinoAgachado);
  cactusImg.resize(AnchoCactus, AltoCactus);
  
  // Posición inicial
  dinoY = height - AlturaDino - 20; // 20 es la altura del suelo
  dinoVel = 0;
  
  // Posición inicial de los cactus
  cactusX[0] = width + random(50, 100);
  cactusX[1] = width + random(150, 250);
}

void draw() {
  background(255); // Fondo blanco
  
  if (!gameOver) {
    actualizarDino();
    actualizarCactus();
    actualizarPuntos();
    verificarColision();
  }
  
  dibujarSuelo();
  dibujarCactus(); // Ahora usa imágenes
  dibujarDino();
  dibujarPuntos();
  
  if (gameOver) {
    dibujarGameOver();
  }
}

void dibujarDino() {
  if (agachado) {
    image(dinoAgachadoImg, 20, dinoY + (AlturaDino - AltoDinoAgachado));
  } else {
    image(dinoImg, 20, dinoY);
  }
}

void dibujarCactus() {
  for (int i = 0; i < cactusX.length; i++) {
    image(cactusImg, cactusX[i], height - AltoCactus - 20);
  }
}

void actualizarDino() {
  if (saltando) {
    dinoY += dinoVel;
    dinoVel += GRAVEDAD;
    
    // Limitar posición para no pasar del suelo
    float AnchoDino = agachado ? AltoDinoAgachado : AlturaDino;
    if (dinoY > height - AnchoDino - 20) {
      dinoY = height - AnchoDino - 20;
      saltando = false;
      dinoVel = 0;
    }
  }
}

void dibujarSuelo() {
  stroke(0);
  line(0, height-20, width, height-20);
}

void actualizarCactus() {
  for (int i = 0; i < cactusX.length; i++) {
    cactusX[i] -= cactusVel;
    
    if (cactusX[i] < -AnchoCactus) {
      cactusX[i] = width + random(100, 200);
    }
  }
}

void actualizarPuntos() {
  Puntos++;
  
  // Aumentar dificultad progresiva
  if (Puntos % 500 == 0) {
    cactusVel += 0.1;
  }
}

void verificarColision() {
  for (int i = 0; i < cactusX.length; i++) {
    if (20 < cactusX[i] + AnchoCactus && 
        20 + (agachado ? AnchoDinoAgachado : AnchoDino) > cactusX[i] && 
        dinoY < height - 20 && 
        dinoY + (agachado ? AltoDinoAgachado : AlturaDino) > height - AltoCactus - 20) {
      gameOver = true;
    }
  }
}

void dibujarPuntos() {
  fill(0);
  textSize(10);
  text("Puntos: " + (Puntos/10), 10, 20);
}

void dibujarGameOver() {
  fill(0);
  textSize(14);
  text("GAME OVER", width/2 - 35, height/2);
  textSize(10);
  text("Press R", width/2 - 20, height/2 + 20);
}

void keyPressed() {
  if (key == ' ' && !saltando && !agachado && !gameOver) {
    saltando = true;
    dinoVel = Salto;
  }
  
  if (keyCode == DOWN) {
    agachado = true;
    if (saltando) {
      dinoVel = min(abs(dinoVel) * 1.2, 10);
    }
  }
  
  if (key == 'r' || key == 'R') {
    reiniciarJuego();
  }
}

void keyReleased() {
  if (keyCode == DOWN) {
    agachado = false;
  }
}

void reiniciarJuego() {
  gameOver = false;
  Puntos = 0;
  dinoY = height - AlturaDino - 20;
  dinoVel = 0;
  saltando = false;
  agachado = false;
  cactusVel = 1.5;
  
  cactusX[0] = width + random(100, 200);
  cactusX[1] = width + random(200, 300);
}
