import { PrismaClient } from "@prisma/client"

const prisma = new PrismaClient()

async function addAlice() {
  const user = await prisma.user.create({
    data: {
      name: "alice",
      email: "bob@alice.info",
    },
  });
  console.log(user);
}

async function retrieveAlices() {
  const users = await prisma.user.findMany({
    include: {
      posts: true,
    },
  });
  console.dir(users);
}

async function addNestedBob() {
  const user = await prisma.user.create({
    data: {
      name: "bob",
      email: "your_uncle@bob.info",
      posts: {
        create: {
          title: "who's your uncle?",
        },
      },
    },
  });
}

async function main() {
  // addAlice();
  // addNestedBob();
  retrieveAlices();
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
