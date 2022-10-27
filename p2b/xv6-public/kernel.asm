
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 56 11 80       	mov    $0x801156d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 34 2a 10 80       	mov    $0x80102a34,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
  struct buf *b;

  acquire(&bcache.lock);
80100041:	68 20 a5 10 80       	push   $0x8010a520
80100046:	e8 76 3c 00 00       	call   80103cc1 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010005f:	74 30                	je     80100091 <bget+0x5d>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	83 c0 01             	add    $0x1,%eax
80100071:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100074:	83 ec 0c             	sub    $0xc,%esp
80100077:	68 20 a5 10 80       	push   $0x8010a520
8010007c:	e8 a5 3c 00 00       	call   80103d26 <release>
      acquiresleep(&b->lock);
80100081:	8d 43 0c             	lea    0xc(%ebx),%eax
80100084:	89 04 24             	mov    %eax,(%esp)
80100087:	e8 21 3a 00 00       	call   80103aad <acquiresleep>
      return b;
8010008c:	83 c4 10             	add    $0x10,%esp
8010008f:	eb 4c                	jmp    801000dd <bget+0xa9>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100091:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100097:	eb 03                	jmp    8010009c <bget+0x68>
80100099:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009c:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000a2:	74 43                	je     801000e7 <bget+0xb3>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a4:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a8:	75 ef                	jne    80100099 <bget+0x65>
801000aa:	f6 03 04             	testb  $0x4,(%ebx)
801000ad:	75 ea                	jne    80100099 <bget+0x65>
      b->dev = dev;
801000af:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b2:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000bb:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c2:	83 ec 0c             	sub    $0xc,%esp
801000c5:	68 20 a5 10 80       	push   $0x8010a520
801000ca:	e8 57 3c 00 00       	call   80103d26 <release>
      acquiresleep(&b->lock);
801000cf:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d2:	89 04 24             	mov    %eax,(%esp)
801000d5:	e8 d3 39 00 00       	call   80103aad <acquiresleep>
      return b;
801000da:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000dd:	89 d8                	mov    %ebx,%eax
801000df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e2:	5b                   	pop    %ebx
801000e3:	5e                   	pop    %esi
801000e4:	5f                   	pop    %edi
801000e5:	5d                   	pop    %ebp
801000e6:	c3                   	ret    
  panic("bget: no buffers");
801000e7:	83 ec 0c             	sub    $0xc,%esp
801000ea:	68 20 67 10 80       	push   $0x80106720
801000ef:	e8 54 02 00 00       	call   80100348 <panic>

801000f4 <binit>:
{
801000f4:	55                   	push   %ebp
801000f5:	89 e5                	mov    %esp,%ebp
801000f7:	53                   	push   %ebx
801000f8:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000fb:	68 31 67 10 80       	push   $0x80106731
80100100:	68 20 a5 10 80       	push   $0x8010a520
80100105:	e8 7b 3a 00 00       	call   80103b85 <initlock>
  bcache.head.prev = &bcache.head;
8010010a:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
80100111:	ec 10 80 
  bcache.head.next = &bcache.head;
80100114:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
8010011b:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010011e:	83 c4 10             	add    $0x10,%esp
80100121:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
80100126:	eb 37                	jmp    8010015f <binit+0x6b>
    b->next = bcache.head.next;
80100128:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010012d:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100130:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100137:	83 ec 08             	sub    $0x8,%esp
8010013a:	68 38 67 10 80       	push   $0x80106738
8010013f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100142:	50                   	push   %eax
80100143:	e8 32 39 00 00       	call   80103a7a <initsleeplock>
    bcache.head.next->prev = b;
80100148:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010014d:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100150:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100156:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010015c:	83 c4 10             	add    $0x10,%esp
8010015f:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100165:	72 c1                	jb     80100128 <binit+0x34>
}
80100167:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010016a:	c9                   	leave  
8010016b:	c3                   	ret    

8010016c <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
8010016c:	55                   	push   %ebp
8010016d:	89 e5                	mov    %esp,%ebp
8010016f:	53                   	push   %ebx
80100170:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100173:	8b 55 0c             	mov    0xc(%ebp),%edx
80100176:	8b 45 08             	mov    0x8(%ebp),%eax
80100179:	e8 b6 fe ff ff       	call   80100034 <bget>
8010017e:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
80100180:	f6 00 02             	testb  $0x2,(%eax)
80100183:	74 07                	je     8010018c <bread+0x20>
    iderw(b);
  }
  return b;
}
80100185:	89 d8                	mov    %ebx,%eax
80100187:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010018a:	c9                   	leave  
8010018b:	c3                   	ret    
    iderw(b);
8010018c:	83 ec 0c             	sub    $0xc,%esp
8010018f:	50                   	push   %eax
80100190:	e8 62 1c 00 00       	call   80101df7 <iderw>
80100195:	83 c4 10             	add    $0x10,%esp
  return b;
80100198:	eb eb                	jmp    80100185 <bread+0x19>

8010019a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
8010019a:	55                   	push   %ebp
8010019b:	89 e5                	mov    %esp,%ebp
8010019d:	53                   	push   %ebx
8010019e:	83 ec 10             	sub    $0x10,%esp
801001a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001a4:	8d 43 0c             	lea    0xc(%ebx),%eax
801001a7:	50                   	push   %eax
801001a8:	e8 8a 39 00 00       	call   80103b37 <holdingsleep>
801001ad:	83 c4 10             	add    $0x10,%esp
801001b0:	85 c0                	test   %eax,%eax
801001b2:	74 14                	je     801001c8 <bwrite+0x2e>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b4:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001b7:	83 ec 0c             	sub    $0xc,%esp
801001ba:	53                   	push   %ebx
801001bb:	e8 37 1c 00 00       	call   80101df7 <iderw>
}
801001c0:	83 c4 10             	add    $0x10,%esp
801001c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c6:	c9                   	leave  
801001c7:	c3                   	ret    
    panic("bwrite");
801001c8:	83 ec 0c             	sub    $0xc,%esp
801001cb:	68 3f 67 10 80       	push   $0x8010673f
801001d0:	e8 73 01 00 00       	call   80100348 <panic>

801001d5 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001d5:	55                   	push   %ebp
801001d6:	89 e5                	mov    %esp,%ebp
801001d8:	56                   	push   %esi
801001d9:	53                   	push   %ebx
801001da:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001dd:	8d 73 0c             	lea    0xc(%ebx),%esi
801001e0:	83 ec 0c             	sub    $0xc,%esp
801001e3:	56                   	push   %esi
801001e4:	e8 4e 39 00 00       	call   80103b37 <holdingsleep>
801001e9:	83 c4 10             	add    $0x10,%esp
801001ec:	85 c0                	test   %eax,%eax
801001ee:	74 6b                	je     8010025b <brelse+0x86>
    panic("brelse");

  releasesleep(&b->lock);
801001f0:	83 ec 0c             	sub    $0xc,%esp
801001f3:	56                   	push   %esi
801001f4:	e8 03 39 00 00       	call   80103afc <releasesleep>

  acquire(&bcache.lock);
801001f9:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100200:	e8 bc 3a 00 00       	call   80103cc1 <acquire>
  b->refcnt--;
80100205:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100208:	83 e8 01             	sub    $0x1,%eax
8010020b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010020e:	83 c4 10             	add    $0x10,%esp
80100211:	85 c0                	test   %eax,%eax
80100213:	75 2f                	jne    80100244 <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100215:	8b 43 54             	mov    0x54(%ebx),%eax
80100218:	8b 53 50             	mov    0x50(%ebx),%edx
8010021b:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021e:	8b 43 50             	mov    0x50(%ebx),%eax
80100221:	8b 53 54             	mov    0x54(%ebx),%edx
80100224:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100227:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010022c:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010022f:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    bcache.head.next->prev = b;
80100236:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010023b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023e:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
80100244:	83 ec 0c             	sub    $0xc,%esp
80100247:	68 20 a5 10 80       	push   $0x8010a520
8010024c:	e8 d5 3a 00 00       	call   80103d26 <release>
}
80100251:	83 c4 10             	add    $0x10,%esp
80100254:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100257:	5b                   	pop    %ebx
80100258:	5e                   	pop    %esi
80100259:	5d                   	pop    %ebp
8010025a:	c3                   	ret    
    panic("brelse");
8010025b:	83 ec 0c             	sub    $0xc,%esp
8010025e:	68 46 67 10 80       	push   $0x80106746
80100263:	e8 e0 00 00 00       	call   80100348 <panic>

80100268 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100268:	55                   	push   %ebp
80100269:	89 e5                	mov    %esp,%ebp
8010026b:	57                   	push   %edi
8010026c:	56                   	push   %esi
8010026d:	53                   	push   %ebx
8010026e:	83 ec 28             	sub    $0x28,%esp
80100271:	8b 7d 08             	mov    0x8(%ebp),%edi
80100274:	8b 75 0c             	mov    0xc(%ebp),%esi
80100277:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010027a:	57                   	push   %edi
8010027b:	e8 b1 13 00 00       	call   80101631 <iunlock>
  target = n;
80100280:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100283:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
8010028a:	e8 32 3a 00 00       	call   80103cc1 <acquire>
  while(n > 0){
8010028f:	83 c4 10             	add    $0x10,%esp
80100292:	85 db                	test   %ebx,%ebx
80100294:	0f 8e 8f 00 00 00    	jle    80100329 <consoleread+0xc1>
    while(input.r == input.w){
8010029a:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010029f:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002a5:	75 47                	jne    801002ee <consoleread+0x86>
      if(myproc()->killed){
801002a7:	e8 16 2f 00 00       	call   801031c2 <myproc>
801002ac:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002b0:	75 17                	jne    801002c9 <consoleread+0x61>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b2:	83 ec 08             	sub    $0x8,%esp
801002b5:	68 20 ef 10 80       	push   $0x8010ef20
801002ba:	68 00 ef 10 80       	push   $0x8010ef00
801002bf:	e8 4a 34 00 00       	call   8010370e <sleep>
801002c4:	83 c4 10             	add    $0x10,%esp
801002c7:	eb d1                	jmp    8010029a <consoleread+0x32>
        release(&cons.lock);
801002c9:	83 ec 0c             	sub    $0xc,%esp
801002cc:	68 20 ef 10 80       	push   $0x8010ef20
801002d1:	e8 50 3a 00 00       	call   80103d26 <release>
        ilock(ip);
801002d6:	89 3c 24             	mov    %edi,(%esp)
801002d9:	e8 91 12 00 00       	call   8010156f <ilock>
        return -1;
801002de:	83 c4 10             	add    $0x10,%esp
801002e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002e9:	5b                   	pop    %ebx
801002ea:	5e                   	pop    %esi
801002eb:	5f                   	pop    %edi
801002ec:	5d                   	pop    %ebp
801002ed:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
801002ee:	8d 50 01             	lea    0x1(%eax),%edx
801002f1:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
801002f7:	89 c2                	mov    %eax,%edx
801002f9:	83 e2 7f             	and    $0x7f,%edx
801002fc:	0f b6 92 80 ee 10 80 	movzbl -0x7fef1180(%edx),%edx
80100303:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
80100306:	80 fa 04             	cmp    $0x4,%dl
80100309:	74 14                	je     8010031f <consoleread+0xb7>
    *dst++ = c;
8010030b:	8d 46 01             	lea    0x1(%esi),%eax
8010030e:	88 16                	mov    %dl,(%esi)
    --n;
80100310:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100313:	83 f9 0a             	cmp    $0xa,%ecx
80100316:	74 11                	je     80100329 <consoleread+0xc1>
    *dst++ = c;
80100318:	89 c6                	mov    %eax,%esi
8010031a:	e9 73 ff ff ff       	jmp    80100292 <consoleread+0x2a>
      if(n < target){
8010031f:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100322:	73 05                	jae    80100329 <consoleread+0xc1>
        input.r--;
80100324:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
  release(&cons.lock);
80100329:	83 ec 0c             	sub    $0xc,%esp
8010032c:	68 20 ef 10 80       	push   $0x8010ef20
80100331:	e8 f0 39 00 00       	call   80103d26 <release>
  ilock(ip);
80100336:	89 3c 24             	mov    %edi,(%esp)
80100339:	e8 31 12 00 00       	call   8010156f <ilock>
  return target - n;
8010033e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100341:	29 d8                	sub    %ebx,%eax
80100343:	83 c4 10             	add    $0x10,%esp
80100346:	eb 9e                	jmp    801002e6 <consoleread+0x7e>

80100348 <panic>:
{
80100348:	55                   	push   %ebp
80100349:	89 e5                	mov    %esp,%ebp
8010034b:	53                   	push   %ebx
8010034c:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010034f:	fa                   	cli    
  cons.locking = 0;
80100350:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100357:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
8010035a:	e8 01 20 00 00       	call   80102360 <lapicid>
8010035f:	83 ec 08             	sub    $0x8,%esp
80100362:	50                   	push   %eax
80100363:	68 4d 67 10 80       	push   $0x8010674d
80100368:	e8 9a 02 00 00       	call   80100607 <cprintf>
  cprintf(s);
8010036d:	83 c4 04             	add    $0x4,%esp
80100370:	ff 75 08             	push   0x8(%ebp)
80100373:	e8 8f 02 00 00       	call   80100607 <cprintf>
  cprintf("\n");
80100378:	c7 04 24 87 70 10 80 	movl   $0x80107087,(%esp)
8010037f:	e8 83 02 00 00       	call   80100607 <cprintf>
  getcallerpcs(&s, pcs);
80100384:	83 c4 08             	add    $0x8,%esp
80100387:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010038a:	50                   	push   %eax
8010038b:	8d 45 08             	lea    0x8(%ebp),%eax
8010038e:	50                   	push   %eax
8010038f:	e8 0c 38 00 00       	call   80103ba0 <getcallerpcs>
  for(i=0; i<10; i++)
80100394:	83 c4 10             	add    $0x10,%esp
80100397:	bb 00 00 00 00       	mov    $0x0,%ebx
8010039c:	eb 17                	jmp    801003b5 <panic+0x6d>
    cprintf(" %p", pcs[i]);
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	ff 74 9d d0          	push   -0x30(%ebp,%ebx,4)
801003a5:	68 61 67 10 80       	push   $0x80106761
801003aa:	e8 58 02 00 00       	call   80100607 <cprintf>
  for(i=0; i<10; i++)
801003af:	83 c3 01             	add    $0x1,%ebx
801003b2:	83 c4 10             	add    $0x10,%esp
801003b5:	83 fb 09             	cmp    $0x9,%ebx
801003b8:	7e e4                	jle    8010039e <panic+0x56>
  panicked = 1; // freeze other CPU
801003ba:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003c1:	00 00 00 
  for(;;)
801003c4:	eb fe                	jmp    801003c4 <panic+0x7c>

801003c6 <cgaputc>:
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	57                   	push   %edi
801003ca:	56                   	push   %esi
801003cb:	53                   	push   %ebx
801003cc:	83 ec 0c             	sub    $0xc,%esp
801003cf:	89 c3                	mov    %eax,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003d1:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003d6:	b8 0e 00 00 00       	mov    $0xe,%eax
801003db:	89 fa                	mov    %edi,%edx
801003dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003de:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003e3:	89 ca                	mov    %ecx,%edx
801003e5:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003e6:	0f b6 f0             	movzbl %al,%esi
801003e9:	c1 e6 08             	shl    $0x8,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003ec:	b8 0f 00 00 00       	mov    $0xf,%eax
801003f1:	89 fa                	mov    %edi,%edx
801003f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f4:	89 ca                	mov    %ecx,%edx
801003f6:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801003f7:	0f b6 c8             	movzbl %al,%ecx
801003fa:	09 f1                	or     %esi,%ecx
  if(c == '\n')
801003fc:	83 fb 0a             	cmp    $0xa,%ebx
801003ff:	74 60                	je     80100461 <cgaputc+0x9b>
  else if(c == BACKSPACE){
80100401:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100407:	74 79                	je     80100482 <cgaputc+0xbc>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100409:	0f b6 c3             	movzbl %bl,%eax
8010040c:	8d 59 01             	lea    0x1(%ecx),%ebx
8010040f:	80 cc 07             	or     $0x7,%ah
80100412:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
80100419:	80 
  if(pos < 0 || pos > 25*80)
8010041a:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100420:	77 6d                	ja     8010048f <cgaputc+0xc9>
  if((pos/80) >= 24){  // Scroll up.
80100422:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100428:	7f 72                	jg     8010049c <cgaputc+0xd6>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010042a:	be d4 03 00 00       	mov    $0x3d4,%esi
8010042f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100434:	89 f2                	mov    %esi,%edx
80100436:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100437:	0f b6 c7             	movzbl %bh,%eax
8010043a:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010043f:	89 ca                	mov    %ecx,%edx
80100441:	ee                   	out    %al,(%dx)
80100442:	b8 0f 00 00 00       	mov    $0xf,%eax
80100447:	89 f2                	mov    %esi,%edx
80100449:	ee                   	out    %al,(%dx)
8010044a:	89 d8                	mov    %ebx,%eax
8010044c:	89 ca                	mov    %ecx,%edx
8010044e:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010044f:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100456:	80 20 07 
}
80100459:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010045c:	5b                   	pop    %ebx
8010045d:	5e                   	pop    %esi
8010045e:	5f                   	pop    %edi
8010045f:	5d                   	pop    %ebp
80100460:	c3                   	ret    
    pos += 80 - pos%80;
80100461:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100466:	89 c8                	mov    %ecx,%eax
80100468:	f7 ea                	imul   %edx
8010046a:	c1 fa 05             	sar    $0x5,%edx
8010046d:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100470:	c1 e0 04             	shl    $0x4,%eax
80100473:	89 ca                	mov    %ecx,%edx
80100475:	29 c2                	sub    %eax,%edx
80100477:	bb 50 00 00 00       	mov    $0x50,%ebx
8010047c:	29 d3                	sub    %edx,%ebx
8010047e:	01 cb                	add    %ecx,%ebx
80100480:	eb 98                	jmp    8010041a <cgaputc+0x54>
    if(pos > 0) --pos;
80100482:	85 c9                	test   %ecx,%ecx
80100484:	7e 05                	jle    8010048b <cgaputc+0xc5>
80100486:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100489:	eb 8f                	jmp    8010041a <cgaputc+0x54>
  pos |= inb(CRTPORT+1);
8010048b:	89 cb                	mov    %ecx,%ebx
8010048d:	eb 8b                	jmp    8010041a <cgaputc+0x54>
    panic("pos under/overflow");
8010048f:	83 ec 0c             	sub    $0xc,%esp
80100492:	68 65 67 10 80       	push   $0x80106765
80100497:	e8 ac fe ff ff       	call   80100348 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010049c:	83 ec 04             	sub    $0x4,%esp
8010049f:	68 60 0e 00 00       	push   $0xe60
801004a4:	68 a0 80 0b 80       	push   $0x800b80a0
801004a9:	68 00 80 0b 80       	push   $0x800b8000
801004ae:	e8 32 39 00 00       	call   80103de5 <memmove>
    pos -= 80;
801004b3:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004b6:	b8 80 07 00 00       	mov    $0x780,%eax
801004bb:	29 d8                	sub    %ebx,%eax
801004bd:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801004c4:	83 c4 0c             	add    $0xc,%esp
801004c7:	01 c0                	add    %eax,%eax
801004c9:	50                   	push   %eax
801004ca:	6a 00                	push   $0x0
801004cc:	52                   	push   %edx
801004cd:	e8 9b 38 00 00       	call   80103d6d <memset>
801004d2:	83 c4 10             	add    $0x10,%esp
801004d5:	e9 50 ff ff ff       	jmp    8010042a <cgaputc+0x64>

801004da <consputc>:
  if(panicked){
801004da:	83 3d 58 ef 10 80 00 	cmpl   $0x0,0x8010ef58
801004e1:	74 03                	je     801004e6 <consputc+0xc>
  asm volatile("cli");
801004e3:	fa                   	cli    
    for(;;)
801004e4:	eb fe                	jmp    801004e4 <consputc+0xa>
{
801004e6:	55                   	push   %ebp
801004e7:	89 e5                	mov    %esp,%ebp
801004e9:	53                   	push   %ebx
801004ea:	83 ec 04             	sub    $0x4,%esp
801004ed:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
801004ef:	3d 00 01 00 00       	cmp    $0x100,%eax
801004f4:	74 18                	je     8010050e <consputc+0x34>
    uartputc(c);
801004f6:	83 ec 0c             	sub    $0xc,%esp
801004f9:	50                   	push   %eax
801004fa:	e8 ac 4c 00 00       	call   801051ab <uartputc>
801004ff:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100502:	89 d8                	mov    %ebx,%eax
80100504:	e8 bd fe ff ff       	call   801003c6 <cgaputc>
}
80100509:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010050c:	c9                   	leave  
8010050d:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010050e:	83 ec 0c             	sub    $0xc,%esp
80100511:	6a 08                	push   $0x8
80100513:	e8 93 4c 00 00       	call   801051ab <uartputc>
80100518:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010051f:	e8 87 4c 00 00       	call   801051ab <uartputc>
80100524:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052b:	e8 7b 4c 00 00       	call   801051ab <uartputc>
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	eb cd                	jmp    80100502 <consputc+0x28>

80100535 <printint>:
{
80100535:	55                   	push   %ebp
80100536:	89 e5                	mov    %esp,%ebp
80100538:	57                   	push   %edi
80100539:	56                   	push   %esi
8010053a:	53                   	push   %ebx
8010053b:	83 ec 2c             	sub    $0x2c,%esp
8010053e:	89 d6                	mov    %edx,%esi
80100540:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100543:	85 c9                	test   %ecx,%ecx
80100545:	74 0c                	je     80100553 <printint+0x1e>
80100547:	89 c7                	mov    %eax,%edi
80100549:	c1 ef 1f             	shr    $0x1f,%edi
8010054c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010054f:	85 c0                	test   %eax,%eax
80100551:	78 38                	js     8010058b <printint+0x56>
    x = xx;
80100553:	89 c1                	mov    %eax,%ecx
  i = 0;
80100555:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
8010055a:	89 c8                	mov    %ecx,%eax
8010055c:	ba 00 00 00 00       	mov    $0x0,%edx
80100561:	f7 f6                	div    %esi
80100563:	89 df                	mov    %ebx,%edi
80100565:	83 c3 01             	add    $0x1,%ebx
80100568:	0f b6 92 90 67 10 80 	movzbl -0x7fef9870(%edx),%edx
8010056f:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
80100573:	89 ca                	mov    %ecx,%edx
80100575:	89 c1                	mov    %eax,%ecx
80100577:	39 d6                	cmp    %edx,%esi
80100579:	76 df                	jbe    8010055a <printint+0x25>
  if(sign)
8010057b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010057f:	74 1a                	je     8010059b <printint+0x66>
    buf[i++] = '-';
80100581:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
80100586:	8d 5f 02             	lea    0x2(%edi),%ebx
80100589:	eb 10                	jmp    8010059b <printint+0x66>
    x = -xx;
8010058b:	f7 d8                	neg    %eax
8010058d:	89 c1                	mov    %eax,%ecx
8010058f:	eb c4                	jmp    80100555 <printint+0x20>
    consputc(buf[i]);
80100591:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
80100596:	e8 3f ff ff ff       	call   801004da <consputc>
  while(--i >= 0)
8010059b:	83 eb 01             	sub    $0x1,%ebx
8010059e:	79 f1                	jns    80100591 <printint+0x5c>
}
801005a0:	83 c4 2c             	add    $0x2c,%esp
801005a3:	5b                   	pop    %ebx
801005a4:	5e                   	pop    %esi
801005a5:	5f                   	pop    %edi
801005a6:	5d                   	pop    %ebp
801005a7:	c3                   	ret    

801005a8 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005a8:	55                   	push   %ebp
801005a9:	89 e5                	mov    %esp,%ebp
801005ab:	57                   	push   %edi
801005ac:	56                   	push   %esi
801005ad:	53                   	push   %ebx
801005ae:	83 ec 18             	sub    $0x18,%esp
801005b1:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005b4:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005b7:	ff 75 08             	push   0x8(%ebp)
801005ba:	e8 72 10 00 00       	call   80101631 <iunlock>
  acquire(&cons.lock);
801005bf:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005c6:	e8 f6 36 00 00       	call   80103cc1 <acquire>
  for(i = 0; i < n; i++)
801005cb:	83 c4 10             	add    $0x10,%esp
801005ce:	bb 00 00 00 00       	mov    $0x0,%ebx
801005d3:	eb 0c                	jmp    801005e1 <consolewrite+0x39>
    consputc(buf[i] & 0xff);
801005d5:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005d9:	e8 fc fe ff ff       	call   801004da <consputc>
  for(i = 0; i < n; i++)
801005de:	83 c3 01             	add    $0x1,%ebx
801005e1:	39 f3                	cmp    %esi,%ebx
801005e3:	7c f0                	jl     801005d5 <consolewrite+0x2d>
  release(&cons.lock);
801005e5:	83 ec 0c             	sub    $0xc,%esp
801005e8:	68 20 ef 10 80       	push   $0x8010ef20
801005ed:	e8 34 37 00 00       	call   80103d26 <release>
  ilock(ip);
801005f2:	83 c4 04             	add    $0x4,%esp
801005f5:	ff 75 08             	push   0x8(%ebp)
801005f8:	e8 72 0f 00 00       	call   8010156f <ilock>

  return n;
}
801005fd:	89 f0                	mov    %esi,%eax
801005ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100602:	5b                   	pop    %ebx
80100603:	5e                   	pop    %esi
80100604:	5f                   	pop    %edi
80100605:	5d                   	pop    %ebp
80100606:	c3                   	ret    

80100607 <cprintf>:
{
80100607:	55                   	push   %ebp
80100608:	89 e5                	mov    %esp,%ebp
8010060a:	57                   	push   %edi
8010060b:	56                   	push   %esi
8010060c:	53                   	push   %ebx
8010060d:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100610:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
80100615:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100618:	85 c0                	test   %eax,%eax
8010061a:	75 10                	jne    8010062c <cprintf+0x25>
  if (fmt == 0)
8010061c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80100620:	74 1c                	je     8010063e <cprintf+0x37>
  argp = (uint*)(void*)(&fmt + 1);
80100622:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100625:	be 00 00 00 00       	mov    $0x0,%esi
8010062a:	eb 27                	jmp    80100653 <cprintf+0x4c>
    acquire(&cons.lock);
8010062c:	83 ec 0c             	sub    $0xc,%esp
8010062f:	68 20 ef 10 80       	push   $0x8010ef20
80100634:	e8 88 36 00 00       	call   80103cc1 <acquire>
80100639:	83 c4 10             	add    $0x10,%esp
8010063c:	eb de                	jmp    8010061c <cprintf+0x15>
    panic("null fmt");
8010063e:	83 ec 0c             	sub    $0xc,%esp
80100641:	68 7f 67 10 80       	push   $0x8010677f
80100646:	e8 fd fc ff ff       	call   80100348 <panic>
      consputc(c);
8010064b:	e8 8a fe ff ff       	call   801004da <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100650:	83 c6 01             	add    $0x1,%esi
80100653:	8b 55 08             	mov    0x8(%ebp),%edx
80100656:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
8010065a:	85 c0                	test   %eax,%eax
8010065c:	0f 84 b1 00 00 00    	je     80100713 <cprintf+0x10c>
    if(c != '%'){
80100662:	83 f8 25             	cmp    $0x25,%eax
80100665:	75 e4                	jne    8010064b <cprintf+0x44>
    c = fmt[++i] & 0xff;
80100667:	83 c6 01             	add    $0x1,%esi
8010066a:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
8010066e:	85 db                	test   %ebx,%ebx
80100670:	0f 84 9d 00 00 00    	je     80100713 <cprintf+0x10c>
    switch(c){
80100676:	83 fb 70             	cmp    $0x70,%ebx
80100679:	74 2e                	je     801006a9 <cprintf+0xa2>
8010067b:	7f 22                	jg     8010069f <cprintf+0x98>
8010067d:	83 fb 25             	cmp    $0x25,%ebx
80100680:	74 6c                	je     801006ee <cprintf+0xe7>
80100682:	83 fb 64             	cmp    $0x64,%ebx
80100685:	75 76                	jne    801006fd <cprintf+0xf6>
      printint(*argp++, 10, 1);
80100687:	8d 5f 04             	lea    0x4(%edi),%ebx
8010068a:	8b 07                	mov    (%edi),%eax
8010068c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100691:	ba 0a 00 00 00       	mov    $0xa,%edx
80100696:	e8 9a fe ff ff       	call   80100535 <printint>
8010069b:	89 df                	mov    %ebx,%edi
      break;
8010069d:	eb b1                	jmp    80100650 <cprintf+0x49>
    switch(c){
8010069f:	83 fb 73             	cmp    $0x73,%ebx
801006a2:	74 1d                	je     801006c1 <cprintf+0xba>
801006a4:	83 fb 78             	cmp    $0x78,%ebx
801006a7:	75 54                	jne    801006fd <cprintf+0xf6>
      printint(*argp++, 16, 0);
801006a9:	8d 5f 04             	lea    0x4(%edi),%ebx
801006ac:	8b 07                	mov    (%edi),%eax
801006ae:	b9 00 00 00 00       	mov    $0x0,%ecx
801006b3:	ba 10 00 00 00       	mov    $0x10,%edx
801006b8:	e8 78 fe ff ff       	call   80100535 <printint>
801006bd:	89 df                	mov    %ebx,%edi
      break;
801006bf:	eb 8f                	jmp    80100650 <cprintf+0x49>
      if((s = (char*)*argp++) == 0)
801006c1:	8d 47 04             	lea    0x4(%edi),%eax
801006c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006c7:	8b 1f                	mov    (%edi),%ebx
801006c9:	85 db                	test   %ebx,%ebx
801006cb:	75 12                	jne    801006df <cprintf+0xd8>
        s = "(null)";
801006cd:	bb 78 67 10 80       	mov    $0x80106778,%ebx
801006d2:	eb 0b                	jmp    801006df <cprintf+0xd8>
        consputc(*s);
801006d4:	0f be c0             	movsbl %al,%eax
801006d7:	e8 fe fd ff ff       	call   801004da <consputc>
      for(; *s; s++)
801006dc:	83 c3 01             	add    $0x1,%ebx
801006df:	0f b6 03             	movzbl (%ebx),%eax
801006e2:	84 c0                	test   %al,%al
801006e4:	75 ee                	jne    801006d4 <cprintf+0xcd>
      if((s = (char*)*argp++) == 0)
801006e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801006e9:	e9 62 ff ff ff       	jmp    80100650 <cprintf+0x49>
      consputc('%');
801006ee:	b8 25 00 00 00       	mov    $0x25,%eax
801006f3:	e8 e2 fd ff ff       	call   801004da <consputc>
      break;
801006f8:	e9 53 ff ff ff       	jmp    80100650 <cprintf+0x49>
      consputc('%');
801006fd:	b8 25 00 00 00       	mov    $0x25,%eax
80100702:	e8 d3 fd ff ff       	call   801004da <consputc>
      consputc(c);
80100707:	89 d8                	mov    %ebx,%eax
80100709:	e8 cc fd ff ff       	call   801004da <consputc>
      break;
8010070e:	e9 3d ff ff ff       	jmp    80100650 <cprintf+0x49>
  if(locking)
80100713:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100717:	75 08                	jne    80100721 <cprintf+0x11a>
}
80100719:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010071c:	5b                   	pop    %ebx
8010071d:	5e                   	pop    %esi
8010071e:	5f                   	pop    %edi
8010071f:	5d                   	pop    %ebp
80100720:	c3                   	ret    
    release(&cons.lock);
80100721:	83 ec 0c             	sub    $0xc,%esp
80100724:	68 20 ef 10 80       	push   $0x8010ef20
80100729:	e8 f8 35 00 00       	call   80103d26 <release>
8010072e:	83 c4 10             	add    $0x10,%esp
}
80100731:	eb e6                	jmp    80100719 <cprintf+0x112>

80100733 <consoleintr>:
{
80100733:	55                   	push   %ebp
80100734:	89 e5                	mov    %esp,%ebp
80100736:	57                   	push   %edi
80100737:	56                   	push   %esi
80100738:	53                   	push   %ebx
80100739:	83 ec 18             	sub    $0x18,%esp
8010073c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010073f:	68 20 ef 10 80       	push   $0x8010ef20
80100744:	e8 78 35 00 00       	call   80103cc1 <acquire>
  while((c = getc()) >= 0){
80100749:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
8010074c:	be 00 00 00 00       	mov    $0x0,%esi
  while((c = getc()) >= 0){
80100751:	eb 13                	jmp    80100766 <consoleintr+0x33>
    switch(c){
80100753:	83 ff 08             	cmp    $0x8,%edi
80100756:	0f 84 d9 00 00 00    	je     80100835 <consoleintr+0x102>
8010075c:	83 ff 10             	cmp    $0x10,%edi
8010075f:	75 25                	jne    80100786 <consoleintr+0x53>
80100761:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100766:	ff d3                	call   *%ebx
80100768:	89 c7                	mov    %eax,%edi
8010076a:	85 c0                	test   %eax,%eax
8010076c:	0f 88 f5 00 00 00    	js     80100867 <consoleintr+0x134>
    switch(c){
80100772:	83 ff 15             	cmp    $0x15,%edi
80100775:	0f 84 93 00 00 00    	je     8010080e <consoleintr+0xdb>
8010077b:	7e d6                	jle    80100753 <consoleintr+0x20>
8010077d:	83 ff 7f             	cmp    $0x7f,%edi
80100780:	0f 84 af 00 00 00    	je     80100835 <consoleintr+0x102>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100786:	85 ff                	test   %edi,%edi
80100788:	74 dc                	je     80100766 <consoleintr+0x33>
8010078a:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010078f:	89 c2                	mov    %eax,%edx
80100791:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100797:	83 fa 7f             	cmp    $0x7f,%edx
8010079a:	77 ca                	ja     80100766 <consoleintr+0x33>
        c = (c == '\r') ? '\n' : c;
8010079c:	83 ff 0d             	cmp    $0xd,%edi
8010079f:	0f 84 b8 00 00 00    	je     8010085d <consoleintr+0x12a>
        input.buf[input.e++ % INPUT_BUF] = c;
801007a5:	8d 50 01             	lea    0x1(%eax),%edx
801007a8:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
801007ae:	83 e0 7f             	and    $0x7f,%eax
801007b1:	89 f9                	mov    %edi,%ecx
801007b3:	88 88 80 ee 10 80    	mov    %cl,-0x7fef1180(%eax)
        consputc(c);
801007b9:	89 f8                	mov    %edi,%eax
801007bb:	e8 1a fd ff ff       	call   801004da <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007c0:	83 ff 0a             	cmp    $0xa,%edi
801007c3:	0f 94 c0             	sete   %al
801007c6:	83 ff 04             	cmp    $0x4,%edi
801007c9:	0f 94 c2             	sete   %dl
801007cc:	08 d0                	or     %dl,%al
801007ce:	75 10                	jne    801007e0 <consoleintr+0xad>
801007d0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801007d5:	83 e8 80             	sub    $0xffffff80,%eax
801007d8:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801007de:	75 86                	jne    80100766 <consoleintr+0x33>
          input.w = input.e;
801007e0:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007e5:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
801007ea:	83 ec 0c             	sub    $0xc,%esp
801007ed:	68 00 ef 10 80       	push   $0x8010ef00
801007f2:	e8 7f 30 00 00       	call   80103876 <wakeup>
801007f7:	83 c4 10             	add    $0x10,%esp
801007fa:	e9 67 ff ff ff       	jmp    80100766 <consoleintr+0x33>
        input.e--;
801007ff:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
        consputc(BACKSPACE);
80100804:	b8 00 01 00 00       	mov    $0x100,%eax
80100809:	e8 cc fc ff ff       	call   801004da <consputc>
      while(input.e != input.w &&
8010080e:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100813:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100819:	0f 84 47 ff ff ff    	je     80100766 <consoleintr+0x33>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	83 e8 01             	sub    $0x1,%eax
80100822:	89 c2                	mov    %eax,%edx
80100824:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100827:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
8010082e:	75 cf                	jne    801007ff <consoleintr+0xcc>
80100830:	e9 31 ff ff ff       	jmp    80100766 <consoleintr+0x33>
      if(input.e != input.w){
80100835:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010083a:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100840:	0f 84 20 ff ff ff    	je     80100766 <consoleintr+0x33>
        input.e--;
80100846:	83 e8 01             	sub    $0x1,%eax
80100849:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
        consputc(BACKSPACE);
8010084e:	b8 00 01 00 00       	mov    $0x100,%eax
80100853:	e8 82 fc ff ff       	call   801004da <consputc>
80100858:	e9 09 ff ff ff       	jmp    80100766 <consoleintr+0x33>
        c = (c == '\r') ? '\n' : c;
8010085d:	bf 0a 00 00 00       	mov    $0xa,%edi
80100862:	e9 3e ff ff ff       	jmp    801007a5 <consoleintr+0x72>
  release(&cons.lock);
80100867:	83 ec 0c             	sub    $0xc,%esp
8010086a:	68 20 ef 10 80       	push   $0x8010ef20
8010086f:	e8 b2 34 00 00       	call   80103d26 <release>
  if(doprocdump) {
80100874:	83 c4 10             	add    $0x10,%esp
80100877:	85 f6                	test   %esi,%esi
80100879:	75 08                	jne    80100883 <consoleintr+0x150>
}
8010087b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087e:	5b                   	pop    %ebx
8010087f:	5e                   	pop    %esi
80100880:	5f                   	pop    %edi
80100881:	5d                   	pop    %ebp
80100882:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
80100883:	e8 8d 30 00 00       	call   80103915 <procdump>
}
80100888:	eb f1                	jmp    8010087b <consoleintr+0x148>

8010088a <consoleinit>:

void
consoleinit(void)
{
8010088a:	55                   	push   %ebp
8010088b:	89 e5                	mov    %esp,%ebp
8010088d:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100890:	68 88 67 10 80       	push   $0x80106788
80100895:	68 20 ef 10 80       	push   $0x8010ef20
8010089a:	e8 e6 32 00 00       	call   80103b85 <initlock>

  devsw[CONSOLE].write = consolewrite;
8010089f:	c7 05 0c f9 10 80 a8 	movl   $0x801005a8,0x8010f90c
801008a6:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801008a9:	c7 05 08 f9 10 80 68 	movl   $0x80100268,0x8010f908
801008b0:	02 10 80 
  cons.locking = 1;
801008b3:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
801008ba:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801008bd:	83 c4 08             	add    $0x8,%esp
801008c0:	6a 00                	push   $0x0
801008c2:	6a 01                	push   $0x1
801008c4:	e8 98 16 00 00       	call   80101f61 <ioapicenable>
}
801008c9:	83 c4 10             	add    $0x10,%esp
801008cc:	c9                   	leave  
801008cd:	c3                   	ret    

801008ce <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801008ce:	55                   	push   %ebp
801008cf:	89 e5                	mov    %esp,%ebp
801008d1:	57                   	push   %edi
801008d2:	56                   	push   %esi
801008d3:	53                   	push   %ebx
801008d4:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801008da:	e8 e3 28 00 00       	call   801031c2 <myproc>
801008df:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801008e5:	e8 94 1e 00 00       	call   8010277e <begin_op>

  if((ip = namei(path)) == 0){
801008ea:	83 ec 0c             	sub    $0xc,%esp
801008ed:	ff 75 08             	push   0x8(%ebp)
801008f0:	e8 d8 12 00 00       	call   80101bcd <namei>
801008f5:	83 c4 10             	add    $0x10,%esp
801008f8:	85 c0                	test   %eax,%eax
801008fa:	74 56                	je     80100952 <exec+0x84>
801008fc:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801008fe:	83 ec 0c             	sub    $0xc,%esp
80100901:	50                   	push   %eax
80100902:	e8 68 0c 00 00       	call   8010156f <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100907:	6a 34                	push   $0x34
80100909:	6a 00                	push   $0x0
8010090b:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100911:	50                   	push   %eax
80100912:	53                   	push   %ebx
80100913:	e8 49 0e 00 00       	call   80101761 <readi>
80100918:	83 c4 20             	add    $0x20,%esp
8010091b:	83 f8 34             	cmp    $0x34,%eax
8010091e:	75 0c                	jne    8010092c <exec+0x5e>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100920:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100927:	45 4c 46 
8010092a:	74 42                	je     8010096e <exec+0xa0>
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
8010092c:	85 db                	test   %ebx,%ebx
8010092e:	0f 84 c5 02 00 00    	je     80100bf9 <exec+0x32b>
    iunlockput(ip);
80100934:	83 ec 0c             	sub    $0xc,%esp
80100937:	53                   	push   %ebx
80100938:	e8 d9 0d 00 00       	call   80101716 <iunlockput>
    end_op();
8010093d:	e8 b6 1e 00 00       	call   801027f8 <end_op>
80100942:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100945:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010094a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010094d:	5b                   	pop    %ebx
8010094e:	5e                   	pop    %esi
8010094f:	5f                   	pop    %edi
80100950:	5d                   	pop    %ebp
80100951:	c3                   	ret    
    end_op();
80100952:	e8 a1 1e 00 00       	call   801027f8 <end_op>
    cprintf("exec: fail\n");
80100957:	83 ec 0c             	sub    $0xc,%esp
8010095a:	68 a1 67 10 80       	push   $0x801067a1
8010095f:	e8 a3 fc ff ff       	call   80100607 <cprintf>
    return -1;
80100964:	83 c4 10             	add    $0x10,%esp
80100967:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096c:	eb dc                	jmp    8010094a <exec+0x7c>
  if((pgdir = setupkvm()) == 0)
8010096e:	e8 60 5b 00 00       	call   801064d3 <setupkvm>
80100973:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100979:	85 c0                	test   %eax,%eax
8010097b:	0f 84 09 01 00 00    	je     80100a8a <exec+0x1bc>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100981:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
80100987:	bf 00 00 00 00       	mov    $0x0,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010098c:	be 00 00 00 00       	mov    $0x0,%esi
80100991:	eb 0c                	jmp    8010099f <exec+0xd1>
80100993:	83 c6 01             	add    $0x1,%esi
80100996:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
8010099c:	83 c0 20             	add    $0x20,%eax
8010099f:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
801009a6:	39 f2                	cmp    %esi,%edx
801009a8:	0f 8e 98 00 00 00    	jle    80100a46 <exec+0x178>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009ae:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801009b4:	6a 20                	push   $0x20
801009b6:	50                   	push   %eax
801009b7:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801009bd:	50                   	push   %eax
801009be:	53                   	push   %ebx
801009bf:	e8 9d 0d 00 00       	call   80101761 <readi>
801009c4:	83 c4 10             	add    $0x10,%esp
801009c7:	83 f8 20             	cmp    $0x20,%eax
801009ca:	0f 85 ba 00 00 00    	jne    80100a8a <exec+0x1bc>
    if(ph.type != ELF_PROG_LOAD)
801009d0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801009d7:	75 ba                	jne    80100993 <exec+0xc5>
    if(ph.memsz < ph.filesz)
801009d9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801009df:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801009e5:	0f 82 9f 00 00 00    	jb     80100a8a <exec+0x1bc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801009eb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801009f1:	0f 82 93 00 00 00    	jb     80100a8a <exec+0x1bc>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801009f7:	83 ec 04             	sub    $0x4,%esp
801009fa:	50                   	push   %eax
801009fb:	57                   	push   %edi
801009fc:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100a02:	e8 72 59 00 00       	call   80106379 <allocuvm>
80100a07:	89 c7                	mov    %eax,%edi
80100a09:	83 c4 10             	add    $0x10,%esp
80100a0c:	85 c0                	test   %eax,%eax
80100a0e:	74 7a                	je     80100a8a <exec+0x1bc>
    if(ph.vaddr % PGSIZE != 0)
80100a10:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a16:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a1b:	75 6d                	jne    80100a8a <exec+0x1bc>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a1d:	83 ec 0c             	sub    $0xc,%esp
80100a20:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100a26:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100a2c:	53                   	push   %ebx
80100a2d:	50                   	push   %eax
80100a2e:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100a34:	e8 13 58 00 00       	call   8010624c <loaduvm>
80100a39:	83 c4 20             	add    $0x20,%esp
80100a3c:	85 c0                	test   %eax,%eax
80100a3e:	0f 89 4f ff ff ff    	jns    80100993 <exec+0xc5>
80100a44:	eb 44                	jmp    80100a8a <exec+0x1bc>
  iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 c7 0c 00 00       	call   80101716 <iunlockput>
  end_op();
80100a4f:	e8 a4 1d 00 00       	call   801027f8 <end_op>
  sz = PGROUNDUP(sz);
80100a54:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80100a5a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a5f:	83 c4 0c             	add    $0xc,%esp
80100a62:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a68:	52                   	push   %edx
80100a69:	50                   	push   %eax
80100a6a:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100a70:	57                   	push   %edi
80100a71:	e8 03 59 00 00       	call   80106379 <allocuvm>
80100a76:	89 c6                	mov    %eax,%esi
80100a78:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a7e:	83 c4 10             	add    $0x10,%esp
80100a81:	85 c0                	test   %eax,%eax
80100a83:	75 24                	jne    80100aa9 <exec+0x1db>
  ip = 0;
80100a85:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100a8a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a90:	85 c0                	test   %eax,%eax
80100a92:	0f 84 94 fe ff ff    	je     8010092c <exec+0x5e>
    freevm(pgdir);
80100a98:	83 ec 0c             	sub    $0xc,%esp
80100a9b:	50                   	push   %eax
80100a9c:	e8 c2 59 00 00       	call   80106463 <freevm>
80100aa1:	83 c4 10             	add    $0x10,%esp
80100aa4:	e9 83 fe ff ff       	jmp    8010092c <exec+0x5e>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100aa9:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100aaf:	83 ec 08             	sub    $0x8,%esp
80100ab2:	50                   	push   %eax
80100ab3:	57                   	push   %edi
80100ab4:	e8 9f 5a 00 00       	call   80106558 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100ab9:	83 c4 10             	add    $0x10,%esp
80100abc:	bf 00 00 00 00       	mov    $0x0,%edi
80100ac1:	eb 0a                	jmp    80100acd <exec+0x1ff>
    ustack[3+argc] = sp;
80100ac3:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100aca:	83 c7 01             	add    $0x1,%edi
80100acd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ad0:	8d 1c b8             	lea    (%eax,%edi,4),%ebx
80100ad3:	8b 03                	mov    (%ebx),%eax
80100ad5:	85 c0                	test   %eax,%eax
80100ad7:	74 47                	je     80100b20 <exec+0x252>
    if(argc >= MAXARG)
80100ad9:	83 ff 1f             	cmp    $0x1f,%edi
80100adc:	0f 87 0d 01 00 00    	ja     80100bef <exec+0x321>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	50                   	push   %eax
80100ae6:	e8 2b 34 00 00       	call   80103f16 <strlen>
80100aeb:	29 c6                	sub    %eax,%esi
80100aed:	83 ee 01             	sub    $0x1,%esi
80100af0:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100af3:	83 c4 04             	add    $0x4,%esp
80100af6:	ff 33                	push   (%ebx)
80100af8:	e8 19 34 00 00       	call   80103f16 <strlen>
80100afd:	83 c0 01             	add    $0x1,%eax
80100b00:	50                   	push   %eax
80100b01:	ff 33                	push   (%ebx)
80100b03:	56                   	push   %esi
80100b04:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b0a:	e8 97 5b 00 00       	call   801066a6 <copyout>
80100b0f:	83 c4 20             	add    $0x20,%esp
80100b12:	85 c0                	test   %eax,%eax
80100b14:	79 ad                	jns    80100ac3 <exec+0x1f5>
  ip = 0;
80100b16:	bb 00 00 00 00       	mov    $0x0,%ebx
80100b1b:	e9 6a ff ff ff       	jmp    80100a8a <exec+0x1bc>
  ustack[3+argc] = 0;
80100b20:	89 f1                	mov    %esi,%ecx
80100b22:	89 c3                	mov    %eax,%ebx
80100b24:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100b2b:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b2f:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b36:	ff ff ff 
  ustack[1] = argc;
80100b39:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b3f:	8d 14 bd 04 00 00 00 	lea    0x4(,%edi,4),%edx
80100b46:	89 f0                	mov    %esi,%eax
80100b48:	29 d0                	sub    %edx,%eax
80100b4a:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b50:	8d 04 bd 10 00 00 00 	lea    0x10(,%edi,4),%eax
80100b57:	29 c1                	sub    %eax,%ecx
80100b59:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b5b:	50                   	push   %eax
80100b5c:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b62:	50                   	push   %eax
80100b63:	51                   	push   %ecx
80100b64:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b6a:	e8 37 5b 00 00       	call   801066a6 <copyout>
80100b6f:	83 c4 10             	add    $0x10,%esp
80100b72:	85 c0                	test   %eax,%eax
80100b74:	0f 88 10 ff ff ff    	js     80100a8a <exec+0x1bc>
  for(last=s=path; *s; s++)
80100b7a:	8b 55 08             	mov    0x8(%ebp),%edx
80100b7d:	89 d0                	mov    %edx,%eax
80100b7f:	eb 03                	jmp    80100b84 <exec+0x2b6>
80100b81:	83 c0 01             	add    $0x1,%eax
80100b84:	0f b6 08             	movzbl (%eax),%ecx
80100b87:	84 c9                	test   %cl,%cl
80100b89:	74 0a                	je     80100b95 <exec+0x2c7>
    if(*s == '/')
80100b8b:	80 f9 2f             	cmp    $0x2f,%cl
80100b8e:	75 f1                	jne    80100b81 <exec+0x2b3>
      last = s+1;
80100b90:	8d 50 01             	lea    0x1(%eax),%edx
80100b93:	eb ec                	jmp    80100b81 <exec+0x2b3>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100b95:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100b9b:	89 f8                	mov    %edi,%eax
80100b9d:	83 c0 6c             	add    $0x6c,%eax
80100ba0:	83 ec 04             	sub    $0x4,%esp
80100ba3:	6a 10                	push   $0x10
80100ba5:	52                   	push   %edx
80100ba6:	50                   	push   %eax
80100ba7:	e8 2d 33 00 00       	call   80103ed9 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100bac:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100baf:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100bb5:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100bb8:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100bbe:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100bc0:	8b 47 18             	mov    0x18(%edi),%eax
80100bc3:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100bc9:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100bcc:	8b 47 18             	mov    0x18(%edi),%eax
80100bcf:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100bd2:	89 3c 24             	mov    %edi,(%esp)
80100bd5:	e8 a9 54 00 00       	call   80106083 <switchuvm>
  freevm(oldpgdir);
80100bda:	89 1c 24             	mov    %ebx,(%esp)
80100bdd:	e8 81 58 00 00       	call   80106463 <freevm>
  return 0;
80100be2:	83 c4 10             	add    $0x10,%esp
80100be5:	b8 00 00 00 00       	mov    $0x0,%eax
80100bea:	e9 5b fd ff ff       	jmp    8010094a <exec+0x7c>
  ip = 0;
80100bef:	bb 00 00 00 00       	mov    $0x0,%ebx
80100bf4:	e9 91 fe ff ff       	jmp    80100a8a <exec+0x1bc>
  return -1;
80100bf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bfe:	e9 47 fd ff ff       	jmp    8010094a <exec+0x7c>

80100c03 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c03:	55                   	push   %ebp
80100c04:	89 e5                	mov    %esp,%ebp
80100c06:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c09:	68 ad 67 10 80       	push   $0x801067ad
80100c0e:	68 60 ef 10 80       	push   $0x8010ef60
80100c13:	e8 6d 2f 00 00       	call   80103b85 <initlock>
}
80100c18:	83 c4 10             	add    $0x10,%esp
80100c1b:	c9                   	leave  
80100c1c:	c3                   	ret    

80100c1d <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c1d:	55                   	push   %ebp
80100c1e:	89 e5                	mov    %esp,%ebp
80100c20:	53                   	push   %ebx
80100c21:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c24:	68 60 ef 10 80       	push   $0x8010ef60
80100c29:	e8 93 30 00 00       	call   80103cc1 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c2e:	83 c4 10             	add    $0x10,%esp
80100c31:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
80100c36:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100c3c:	73 29                	jae    80100c67 <filealloc+0x4a>
    if(f->ref == 0){
80100c3e:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c42:	74 05                	je     80100c49 <filealloc+0x2c>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c44:	83 c3 18             	add    $0x18,%ebx
80100c47:	eb ed                	jmp    80100c36 <filealloc+0x19>
      f->ref = 1;
80100c49:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c50:	83 ec 0c             	sub    $0xc,%esp
80100c53:	68 60 ef 10 80       	push   $0x8010ef60
80100c58:	e8 c9 30 00 00       	call   80103d26 <release>
      return f;
80100c5d:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100c60:	89 d8                	mov    %ebx,%eax
80100c62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c65:	c9                   	leave  
80100c66:	c3                   	ret    
  release(&ftable.lock);
80100c67:	83 ec 0c             	sub    $0xc,%esp
80100c6a:	68 60 ef 10 80       	push   $0x8010ef60
80100c6f:	e8 b2 30 00 00       	call   80103d26 <release>
  return 0;
80100c74:	83 c4 10             	add    $0x10,%esp
80100c77:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c7c:	eb e2                	jmp    80100c60 <filealloc+0x43>

80100c7e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100c7e:	55                   	push   %ebp
80100c7f:	89 e5                	mov    %esp,%ebp
80100c81:	53                   	push   %ebx
80100c82:	83 ec 10             	sub    $0x10,%esp
80100c85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100c88:	68 60 ef 10 80       	push   $0x8010ef60
80100c8d:	e8 2f 30 00 00       	call   80103cc1 <acquire>
  if(f->ref < 1)
80100c92:	8b 43 04             	mov    0x4(%ebx),%eax
80100c95:	83 c4 10             	add    $0x10,%esp
80100c98:	85 c0                	test   %eax,%eax
80100c9a:	7e 1a                	jle    80100cb6 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100c9c:	83 c0 01             	add    $0x1,%eax
80100c9f:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ca2:	83 ec 0c             	sub    $0xc,%esp
80100ca5:	68 60 ef 10 80       	push   $0x8010ef60
80100caa:	e8 77 30 00 00       	call   80103d26 <release>
  return f;
}
80100caf:	89 d8                	mov    %ebx,%eax
80100cb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cb4:	c9                   	leave  
80100cb5:	c3                   	ret    
    panic("filedup");
80100cb6:	83 ec 0c             	sub    $0xc,%esp
80100cb9:	68 b4 67 10 80       	push   $0x801067b4
80100cbe:	e8 85 f6 ff ff       	call   80100348 <panic>

80100cc3 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100cc3:	55                   	push   %ebp
80100cc4:	89 e5                	mov    %esp,%ebp
80100cc6:	53                   	push   %ebx
80100cc7:	83 ec 30             	sub    $0x30,%esp
80100cca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ccd:	68 60 ef 10 80       	push   $0x8010ef60
80100cd2:	e8 ea 2f 00 00       	call   80103cc1 <acquire>
  if(f->ref < 1)
80100cd7:	8b 43 04             	mov    0x4(%ebx),%eax
80100cda:	83 c4 10             	add    $0x10,%esp
80100cdd:	85 c0                	test   %eax,%eax
80100cdf:	7e 71                	jle    80100d52 <fileclose+0x8f>
    panic("fileclose");
  if(--f->ref > 0){
80100ce1:	83 e8 01             	sub    $0x1,%eax
80100ce4:	89 43 04             	mov    %eax,0x4(%ebx)
80100ce7:	85 c0                	test   %eax,%eax
80100ce9:	7f 74                	jg     80100d5f <fileclose+0x9c>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ceb:	8b 03                	mov    (%ebx),%eax
80100ced:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cf0:	8b 43 04             	mov    0x4(%ebx),%eax
80100cf3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100cf6:	8b 43 08             	mov    0x8(%ebx),%eax
80100cf9:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cfc:	8b 43 0c             	mov    0xc(%ebx),%eax
80100cff:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100d02:	8b 43 10             	mov    0x10(%ebx),%eax
80100d05:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100d08:	8b 43 14             	mov    0x14(%ebx),%eax
80100d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80100d0e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d15:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d1b:	83 ec 0c             	sub    $0xc,%esp
80100d1e:	68 60 ef 10 80       	push   $0x8010ef60
80100d23:	e8 fe 2f 00 00       	call   80103d26 <release>

  if(ff.type == FD_PIPE)
80100d28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2b:	83 c4 10             	add    $0x10,%esp
80100d2e:	83 f8 01             	cmp    $0x1,%eax
80100d31:	74 41                	je     80100d74 <fileclose+0xb1>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100d33:	83 f8 02             	cmp    $0x2,%eax
80100d36:	75 37                	jne    80100d6f <fileclose+0xac>
    begin_op();
80100d38:	e8 41 1a 00 00       	call   8010277e <begin_op>
    iput(ff.ip);
80100d3d:	83 ec 0c             	sub    $0xc,%esp
80100d40:	ff 75 f0             	push   -0x10(%ebp)
80100d43:	e8 2e 09 00 00       	call   80101676 <iput>
    end_op();
80100d48:	e8 ab 1a 00 00       	call   801027f8 <end_op>
80100d4d:	83 c4 10             	add    $0x10,%esp
80100d50:	eb 1d                	jmp    80100d6f <fileclose+0xac>
    panic("fileclose");
80100d52:	83 ec 0c             	sub    $0xc,%esp
80100d55:	68 bc 67 10 80       	push   $0x801067bc
80100d5a:	e8 e9 f5 ff ff       	call   80100348 <panic>
    release(&ftable.lock);
80100d5f:	83 ec 0c             	sub    $0xc,%esp
80100d62:	68 60 ef 10 80       	push   $0x8010ef60
80100d67:	e8 ba 2f 00 00       	call   80103d26 <release>
    return;
80100d6c:	83 c4 10             	add    $0x10,%esp
  }
}
80100d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d72:	c9                   	leave  
80100d73:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100d74:	83 ec 08             	sub    $0x8,%esp
80100d77:	0f be 45 e9          	movsbl -0x17(%ebp),%eax
80100d7b:	50                   	push   %eax
80100d7c:	ff 75 ec             	push   -0x14(%ebp)
80100d7f:	e8 6d 20 00 00       	call   80102df1 <pipeclose>
80100d84:	83 c4 10             	add    $0x10,%esp
80100d87:	eb e6                	jmp    80100d6f <fileclose+0xac>

80100d89 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100d89:	55                   	push   %ebp
80100d8a:	89 e5                	mov    %esp,%ebp
80100d8c:	53                   	push   %ebx
80100d8d:	83 ec 04             	sub    $0x4,%esp
80100d90:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100d93:	83 3b 02             	cmpl   $0x2,(%ebx)
80100d96:	75 31                	jne    80100dc9 <filestat+0x40>
    ilock(f->ip);
80100d98:	83 ec 0c             	sub    $0xc,%esp
80100d9b:	ff 73 10             	push   0x10(%ebx)
80100d9e:	e8 cc 07 00 00       	call   8010156f <ilock>
    stati(f->ip, st);
80100da3:	83 c4 08             	add    $0x8,%esp
80100da6:	ff 75 0c             	push   0xc(%ebp)
80100da9:	ff 73 10             	push   0x10(%ebx)
80100dac:	e8 85 09 00 00       	call   80101736 <stati>
    iunlock(f->ip);
80100db1:	83 c4 04             	add    $0x4,%esp
80100db4:	ff 73 10             	push   0x10(%ebx)
80100db7:	e8 75 08 00 00       	call   80101631 <iunlock>
    return 0;
80100dbc:	83 c4 10             	add    $0x10,%esp
80100dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100dc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dc7:	c9                   	leave  
80100dc8:	c3                   	ret    
  return -1;
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	eb f4                	jmp    80100dc4 <filestat+0x3b>

80100dd0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	56                   	push   %esi
80100dd4:	53                   	push   %ebx
80100dd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100dd8:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100ddc:	74 70                	je     80100e4e <fileread+0x7e>
    return -1;
  if(f->type == FD_PIPE)
80100dde:	8b 03                	mov    (%ebx),%eax
80100de0:	83 f8 01             	cmp    $0x1,%eax
80100de3:	74 44                	je     80100e29 <fileread+0x59>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100de5:	83 f8 02             	cmp    $0x2,%eax
80100de8:	75 57                	jne    80100e41 <fileread+0x71>
    ilock(f->ip);
80100dea:	83 ec 0c             	sub    $0xc,%esp
80100ded:	ff 73 10             	push   0x10(%ebx)
80100df0:	e8 7a 07 00 00       	call   8010156f <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100df5:	ff 75 10             	push   0x10(%ebp)
80100df8:	ff 73 14             	push   0x14(%ebx)
80100dfb:	ff 75 0c             	push   0xc(%ebp)
80100dfe:	ff 73 10             	push   0x10(%ebx)
80100e01:	e8 5b 09 00 00       	call   80101761 <readi>
80100e06:	89 c6                	mov    %eax,%esi
80100e08:	83 c4 20             	add    $0x20,%esp
80100e0b:	85 c0                	test   %eax,%eax
80100e0d:	7e 03                	jle    80100e12 <fileread+0x42>
      f->off += r;
80100e0f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e12:	83 ec 0c             	sub    $0xc,%esp
80100e15:	ff 73 10             	push   0x10(%ebx)
80100e18:	e8 14 08 00 00       	call   80101631 <iunlock>
    return r;
80100e1d:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e20:	89 f0                	mov    %esi,%eax
80100e22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e25:	5b                   	pop    %ebx
80100e26:	5e                   	pop    %esi
80100e27:	5d                   	pop    %ebp
80100e28:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e29:	83 ec 04             	sub    $0x4,%esp
80100e2c:	ff 75 10             	push   0x10(%ebp)
80100e2f:	ff 75 0c             	push   0xc(%ebp)
80100e32:	ff 73 0c             	push   0xc(%ebx)
80100e35:	e8 08 21 00 00       	call   80102f42 <piperead>
80100e3a:	89 c6                	mov    %eax,%esi
80100e3c:	83 c4 10             	add    $0x10,%esp
80100e3f:	eb df                	jmp    80100e20 <fileread+0x50>
  panic("fileread");
80100e41:	83 ec 0c             	sub    $0xc,%esp
80100e44:	68 c6 67 10 80       	push   $0x801067c6
80100e49:	e8 fa f4 ff ff       	call   80100348 <panic>
    return -1;
80100e4e:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e53:	eb cb                	jmp    80100e20 <fileread+0x50>

80100e55 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e55:	55                   	push   %ebp
80100e56:	89 e5                	mov    %esp,%ebp
80100e58:	57                   	push   %edi
80100e59:	56                   	push   %esi
80100e5a:	53                   	push   %ebx
80100e5b:	83 ec 1c             	sub    $0x1c,%esp
80100e5e:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100e61:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100e65:	0f 84 d0 00 00 00    	je     80100f3b <filewrite+0xe6>
    return -1;
  if(f->type == FD_PIPE)
80100e6b:	8b 06                	mov    (%esi),%eax
80100e6d:	83 f8 01             	cmp    $0x1,%eax
80100e70:	74 12                	je     80100e84 <filewrite+0x2f>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e72:	83 f8 02             	cmp    $0x2,%eax
80100e75:	0f 85 b3 00 00 00    	jne    80100f2e <filewrite+0xd9>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100e7b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e82:	eb 66                	jmp    80100eea <filewrite+0x95>
    return pipewrite(f->pipe, addr, n);
80100e84:	83 ec 04             	sub    $0x4,%esp
80100e87:	ff 75 10             	push   0x10(%ebp)
80100e8a:	ff 75 0c             	push   0xc(%ebp)
80100e8d:	ff 76 0c             	push   0xc(%esi)
80100e90:	e8 e8 1f 00 00       	call   80102e7d <pipewrite>
80100e95:	83 c4 10             	add    $0x10,%esp
80100e98:	e9 84 00 00 00       	jmp    80100f21 <filewrite+0xcc>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100e9d:	e8 dc 18 00 00       	call   8010277e <begin_op>
      ilock(f->ip);
80100ea2:	83 ec 0c             	sub    $0xc,%esp
80100ea5:	ff 76 10             	push   0x10(%esi)
80100ea8:	e8 c2 06 00 00       	call   8010156f <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100ead:	57                   	push   %edi
80100eae:	ff 76 14             	push   0x14(%esi)
80100eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eb4:	03 45 0c             	add    0xc(%ebp),%eax
80100eb7:	50                   	push   %eax
80100eb8:	ff 76 10             	push   0x10(%esi)
80100ebb:	e8 9e 09 00 00       	call   8010185e <writei>
80100ec0:	89 c3                	mov    %eax,%ebx
80100ec2:	83 c4 20             	add    $0x20,%esp
80100ec5:	85 c0                	test   %eax,%eax
80100ec7:	7e 03                	jle    80100ecc <filewrite+0x77>
        f->off += r;
80100ec9:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100ecc:	83 ec 0c             	sub    $0xc,%esp
80100ecf:	ff 76 10             	push   0x10(%esi)
80100ed2:	e8 5a 07 00 00       	call   80101631 <iunlock>
      end_op();
80100ed7:	e8 1c 19 00 00       	call   801027f8 <end_op>

      if(r < 0)
80100edc:	83 c4 10             	add    $0x10,%esp
80100edf:	85 db                	test   %ebx,%ebx
80100ee1:	78 31                	js     80100f14 <filewrite+0xbf>
        break;
      if(r != n1)
80100ee3:	39 df                	cmp    %ebx,%edi
80100ee5:	75 20                	jne    80100f07 <filewrite+0xb2>
        panic("short filewrite");
      i += r;
80100ee7:	01 5d e4             	add    %ebx,-0x1c(%ebp)
    while(i < n){
80100eea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eed:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ef0:	7d 22                	jge    80100f14 <filewrite+0xbf>
      int n1 = n - i;
80100ef2:	8b 7d 10             	mov    0x10(%ebp),%edi
80100ef5:	2b 7d e4             	sub    -0x1c(%ebp),%edi
      if(n1 > max)
80100ef8:	81 ff 00 06 00 00    	cmp    $0x600,%edi
80100efe:	7e 9d                	jle    80100e9d <filewrite+0x48>
        n1 = max;
80100f00:	bf 00 06 00 00       	mov    $0x600,%edi
80100f05:	eb 96                	jmp    80100e9d <filewrite+0x48>
        panic("short filewrite");
80100f07:	83 ec 0c             	sub    $0xc,%esp
80100f0a:	68 cf 67 10 80       	push   $0x801067cf
80100f0f:	e8 34 f4 ff ff       	call   80100348 <panic>
    }
    return i == n ? n : -1;
80100f14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f17:	3b 45 10             	cmp    0x10(%ebp),%eax
80100f1a:	74 0d                	je     80100f29 <filewrite+0xd4>
80100f1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100f21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f24:	5b                   	pop    %ebx
80100f25:	5e                   	pop    %esi
80100f26:	5f                   	pop    %edi
80100f27:	5d                   	pop    %ebp
80100f28:	c3                   	ret    
    return i == n ? n : -1;
80100f29:	8b 45 10             	mov    0x10(%ebp),%eax
80100f2c:	eb f3                	jmp    80100f21 <filewrite+0xcc>
  panic("filewrite");
80100f2e:	83 ec 0c             	sub    $0xc,%esp
80100f31:	68 d5 67 10 80       	push   $0x801067d5
80100f36:	e8 0d f4 ff ff       	call   80100348 <panic>
    return -1;
80100f3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f40:	eb df                	jmp    80100f21 <filewrite+0xcc>

80100f42 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100f42:	55                   	push   %ebp
80100f43:	89 e5                	mov    %esp,%ebp
80100f45:	57                   	push   %edi
80100f46:	56                   	push   %esi
80100f47:	53                   	push   %ebx
80100f48:	83 ec 0c             	sub    $0xc,%esp
80100f4b:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100f4d:	eb 03                	jmp    80100f52 <skipelem+0x10>
    path++;
80100f4f:	83 c0 01             	add    $0x1,%eax
  while(*path == '/')
80100f52:	0f b6 10             	movzbl (%eax),%edx
80100f55:	80 fa 2f             	cmp    $0x2f,%dl
80100f58:	74 f5                	je     80100f4f <skipelem+0xd>
  if(*path == 0)
80100f5a:	84 d2                	test   %dl,%dl
80100f5c:	74 53                	je     80100fb1 <skipelem+0x6f>
80100f5e:	89 c3                	mov    %eax,%ebx
80100f60:	eb 03                	jmp    80100f65 <skipelem+0x23>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80100f62:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80100f65:	0f b6 13             	movzbl (%ebx),%edx
80100f68:	80 fa 2f             	cmp    $0x2f,%dl
80100f6b:	74 04                	je     80100f71 <skipelem+0x2f>
80100f6d:	84 d2                	test   %dl,%dl
80100f6f:	75 f1                	jne    80100f62 <skipelem+0x20>
  len = path - s;
80100f71:	89 df                	mov    %ebx,%edi
80100f73:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100f75:	83 ff 0d             	cmp    $0xd,%edi
80100f78:	7e 11                	jle    80100f8b <skipelem+0x49>
    memmove(name, s, DIRSIZ);
80100f7a:	83 ec 04             	sub    $0x4,%esp
80100f7d:	6a 0e                	push   $0xe
80100f7f:	50                   	push   %eax
80100f80:	56                   	push   %esi
80100f81:	e8 5f 2e 00 00       	call   80103de5 <memmove>
80100f86:	83 c4 10             	add    $0x10,%esp
80100f89:	eb 17                	jmp    80100fa2 <skipelem+0x60>
  else {
    memmove(name, s, len);
80100f8b:	83 ec 04             	sub    $0x4,%esp
80100f8e:	57                   	push   %edi
80100f8f:	50                   	push   %eax
80100f90:	56                   	push   %esi
80100f91:	e8 4f 2e 00 00       	call   80103de5 <memmove>
    name[len] = 0;
80100f96:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100f9a:	83 c4 10             	add    $0x10,%esp
80100f9d:	eb 03                	jmp    80100fa2 <skipelem+0x60>
  }
  while(*path == '/')
    path++;
80100f9f:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80100fa2:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100fa5:	74 f8                	je     80100f9f <skipelem+0x5d>
  return path;
}
80100fa7:	89 d8                	mov    %ebx,%eax
80100fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fac:	5b                   	pop    %ebx
80100fad:	5e                   	pop    %esi
80100fae:	5f                   	pop    %edi
80100faf:	5d                   	pop    %ebp
80100fb0:	c3                   	ret    
    return 0;
80100fb1:	bb 00 00 00 00       	mov    $0x0,%ebx
80100fb6:	eb ef                	jmp    80100fa7 <skipelem+0x65>

80100fb8 <bzero>:
{
80100fb8:	55                   	push   %ebp
80100fb9:	89 e5                	mov    %esp,%ebp
80100fbb:	53                   	push   %ebx
80100fbc:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80100fbf:	52                   	push   %edx
80100fc0:	50                   	push   %eax
80100fc1:	e8 a6 f1 ff ff       	call   8010016c <bread>
80100fc6:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80100fc8:	8d 40 5c             	lea    0x5c(%eax),%eax
80100fcb:	83 c4 0c             	add    $0xc,%esp
80100fce:	68 00 02 00 00       	push   $0x200
80100fd3:	6a 00                	push   $0x0
80100fd5:	50                   	push   %eax
80100fd6:	e8 92 2d 00 00       	call   80103d6d <memset>
  log_write(bp);
80100fdb:	89 1c 24             	mov    %ebx,(%esp)
80100fde:	e8 c4 18 00 00       	call   801028a7 <log_write>
  brelse(bp);
80100fe3:	89 1c 24             	mov    %ebx,(%esp)
80100fe6:	e8 ea f1 ff ff       	call   801001d5 <brelse>
}
80100feb:	83 c4 10             	add    $0x10,%esp
80100fee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff1:	c9                   	leave  
80100ff2:	c3                   	ret    

80100ff3 <bfree>:
{
80100ff3:	55                   	push   %ebp
80100ff4:	89 e5                	mov    %esp,%ebp
80100ff6:	56                   	push   %esi
80100ff7:	53                   	push   %ebx
80100ff8:	89 c3                	mov    %eax,%ebx
80100ffa:	89 d6                	mov    %edx,%esi
  bp = bread(dev, BBLOCK(b, sb));
80100ffc:	89 d0                	mov    %edx,%eax
80100ffe:	c1 e8 0c             	shr    $0xc,%eax
80101001:	83 ec 08             	sub    $0x8,%esp
80101004:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010100a:	50                   	push   %eax
8010100b:	53                   	push   %ebx
8010100c:	e8 5b f1 ff ff       	call   8010016c <bread>
80101011:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
80101013:	89 f2                	mov    %esi,%edx
80101015:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  m = 1 << (bi % 8);
8010101b:	89 f1                	mov    %esi,%ecx
8010101d:	83 e1 07             	and    $0x7,%ecx
80101020:	b8 01 00 00 00       	mov    $0x1,%eax
80101025:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101027:	83 c4 10             	add    $0x10,%esp
8010102a:	c1 fa 03             	sar    $0x3,%edx
8010102d:	0f b6 4c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ecx
80101032:	0f b6 f1             	movzbl %cl,%esi
80101035:	85 c6                	test   %eax,%esi
80101037:	74 23                	je     8010105c <bfree+0x69>
  bp->data[bi/8] &= ~m;
80101039:	f7 d0                	not    %eax
8010103b:	21 c8                	and    %ecx,%eax
8010103d:	88 44 13 5c          	mov    %al,0x5c(%ebx,%edx,1)
  log_write(bp);
80101041:	83 ec 0c             	sub    $0xc,%esp
80101044:	53                   	push   %ebx
80101045:	e8 5d 18 00 00       	call   801028a7 <log_write>
  brelse(bp);
8010104a:	89 1c 24             	mov    %ebx,(%esp)
8010104d:	e8 83 f1 ff ff       	call   801001d5 <brelse>
}
80101052:	83 c4 10             	add    $0x10,%esp
80101055:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101058:	5b                   	pop    %ebx
80101059:	5e                   	pop    %esi
8010105a:	5d                   	pop    %ebp
8010105b:	c3                   	ret    
    panic("freeing free block");
8010105c:	83 ec 0c             	sub    $0xc,%esp
8010105f:	68 df 67 10 80       	push   $0x801067df
80101064:	e8 df f2 ff ff       	call   80100348 <panic>

80101069 <balloc>:
{
80101069:	55                   	push   %ebp
8010106a:	89 e5                	mov    %esp,%ebp
8010106c:	57                   	push   %edi
8010106d:	56                   	push   %esi
8010106e:	53                   	push   %ebx
8010106f:	83 ec 1c             	sub    $0x1c,%esp
80101072:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101075:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010107c:	eb 15                	jmp    80101093 <balloc+0x2a>
    brelse(bp);
8010107e:	83 ec 0c             	sub    $0xc,%esp
80101081:	ff 75 e0             	push   -0x20(%ebp)
80101084:	e8 4c f1 ff ff       	call   801001d5 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101089:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
80101090:	83 c4 10             	add    $0x10,%esp
80101093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101096:	39 05 b4 15 11 80    	cmp    %eax,0x801115b4
8010109c:	76 75                	jbe    80101113 <balloc+0xaa>
    bp = bread(dev, BBLOCK(b, sb));
8010109e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010a1:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
801010a7:	85 db                	test   %ebx,%ebx
801010a9:	0f 49 c3             	cmovns %ebx,%eax
801010ac:	c1 f8 0c             	sar    $0xc,%eax
801010af:	83 ec 08             	sub    $0x8,%esp
801010b2:	03 05 cc 15 11 80    	add    0x801115cc,%eax
801010b8:	50                   	push   %eax
801010b9:	ff 75 d8             	push   -0x28(%ebp)
801010bc:	e8 ab f0 ff ff       	call   8010016c <bread>
801010c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010c4:	83 c4 10             	add    $0x10,%esp
801010c7:	b8 00 00 00 00       	mov    $0x0,%eax
801010cc:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801010d1:	7f ab                	jg     8010107e <balloc+0x15>
801010d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801010d6:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
801010d9:	3b 1d b4 15 11 80    	cmp    0x801115b4,%ebx
801010df:	73 9d                	jae    8010107e <balloc+0x15>
      m = 1 << (bi % 8);
801010e1:	89 c1                	mov    %eax,%ecx
801010e3:	83 e1 07             	and    $0x7,%ecx
801010e6:	ba 01 00 00 00       	mov    $0x1,%edx
801010eb:	d3 e2                	shl    %cl,%edx
801010ed:	89 d1                	mov    %edx,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801010ef:	8d 50 07             	lea    0x7(%eax),%edx
801010f2:	85 c0                	test   %eax,%eax
801010f4:	0f 49 d0             	cmovns %eax,%edx
801010f7:	c1 fa 03             	sar    $0x3,%edx
801010fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
801010fd:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101100:	0f b6 74 16 5c       	movzbl 0x5c(%esi,%edx,1),%esi
80101105:	89 f2                	mov    %esi,%edx
80101107:	0f b6 fa             	movzbl %dl,%edi
8010110a:	85 cf                	test   %ecx,%edi
8010110c:	74 12                	je     80101120 <balloc+0xb7>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010110e:	83 c0 01             	add    $0x1,%eax
80101111:	eb b9                	jmp    801010cc <balloc+0x63>
  panic("balloc: out of blocks");
80101113:	83 ec 0c             	sub    $0xc,%esp
80101116:	68 f2 67 10 80       	push   $0x801067f2
8010111b:	e8 28 f2 ff ff       	call   80100348 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
80101120:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101123:	09 f1                	or     %esi,%ecx
80101125:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101128:	88 4c 17 5c          	mov    %cl,0x5c(%edi,%edx,1)
        log_write(bp);
8010112c:	83 ec 0c             	sub    $0xc,%esp
8010112f:	57                   	push   %edi
80101130:	e8 72 17 00 00       	call   801028a7 <log_write>
        brelse(bp);
80101135:	89 3c 24             	mov    %edi,(%esp)
80101138:	e8 98 f0 ff ff       	call   801001d5 <brelse>
        bzero(dev, b + bi);
8010113d:	89 da                	mov    %ebx,%edx
8010113f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101142:	e8 71 fe ff ff       	call   80100fb8 <bzero>
}
80101147:	89 d8                	mov    %ebx,%eax
80101149:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010114c:	5b                   	pop    %ebx
8010114d:	5e                   	pop    %esi
8010114e:	5f                   	pop    %edi
8010114f:	5d                   	pop    %ebp
80101150:	c3                   	ret    

80101151 <bmap>:
{
80101151:	55                   	push   %ebp
80101152:	89 e5                	mov    %esp,%ebp
80101154:	57                   	push   %edi
80101155:	56                   	push   %esi
80101156:	53                   	push   %ebx
80101157:	83 ec 1c             	sub    $0x1c,%esp
8010115a:	89 c3                	mov    %eax,%ebx
8010115c:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
8010115e:	83 fa 0b             	cmp    $0xb,%edx
80101161:	76 45                	jbe    801011a8 <bmap+0x57>
  bn -= NDIRECT;
80101163:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
80101166:	83 fe 7f             	cmp    $0x7f,%esi
80101169:	77 7f                	ja     801011ea <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
8010116b:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101171:	85 c0                	test   %eax,%eax
80101173:	74 4a                	je     801011bf <bmap+0x6e>
    bp = bread(ip->dev, addr);
80101175:	83 ec 08             	sub    $0x8,%esp
80101178:	50                   	push   %eax
80101179:	ff 33                	push   (%ebx)
8010117b:	e8 ec ef ff ff       	call   8010016c <bread>
80101180:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101182:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
80101186:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101189:	8b 30                	mov    (%eax),%esi
8010118b:	83 c4 10             	add    $0x10,%esp
8010118e:	85 f6                	test   %esi,%esi
80101190:	74 3c                	je     801011ce <bmap+0x7d>
    brelse(bp);
80101192:	83 ec 0c             	sub    $0xc,%esp
80101195:	57                   	push   %edi
80101196:	e8 3a f0 ff ff       	call   801001d5 <brelse>
    return addr;
8010119b:	83 c4 10             	add    $0x10,%esp
}
8010119e:	89 f0                	mov    %esi,%eax
801011a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a3:	5b                   	pop    %ebx
801011a4:	5e                   	pop    %esi
801011a5:	5f                   	pop    %edi
801011a6:	5d                   	pop    %ebp
801011a7:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
801011a8:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
801011ac:	85 f6                	test   %esi,%esi
801011ae:	75 ee                	jne    8010119e <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
801011b0:	8b 00                	mov    (%eax),%eax
801011b2:	e8 b2 fe ff ff       	call   80101069 <balloc>
801011b7:	89 c6                	mov    %eax,%esi
801011b9:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
801011bd:	eb df                	jmp    8010119e <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801011bf:	8b 03                	mov    (%ebx),%eax
801011c1:	e8 a3 fe ff ff       	call   80101069 <balloc>
801011c6:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801011cc:	eb a7                	jmp    80101175 <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
801011ce:	8b 03                	mov    (%ebx),%eax
801011d0:	e8 94 fe ff ff       	call   80101069 <balloc>
801011d5:	89 c6                	mov    %eax,%esi
801011d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011da:	89 30                	mov    %esi,(%eax)
      log_write(bp);
801011dc:	83 ec 0c             	sub    $0xc,%esp
801011df:	57                   	push   %edi
801011e0:	e8 c2 16 00 00       	call   801028a7 <log_write>
801011e5:	83 c4 10             	add    $0x10,%esp
801011e8:	eb a8                	jmp    80101192 <bmap+0x41>
  panic("bmap: out of range");
801011ea:	83 ec 0c             	sub    $0xc,%esp
801011ed:	68 08 68 10 80       	push   $0x80106808
801011f2:	e8 51 f1 ff ff       	call   80100348 <panic>

801011f7 <iget>:
{
801011f7:	55                   	push   %ebp
801011f8:	89 e5                	mov    %esp,%ebp
801011fa:	57                   	push   %edi
801011fb:	56                   	push   %esi
801011fc:	53                   	push   %ebx
801011fd:	83 ec 28             	sub    $0x28,%esp
80101200:	89 c7                	mov    %eax,%edi
80101202:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101205:	68 60 f9 10 80       	push   $0x8010f960
8010120a:	e8 b2 2a 00 00       	call   80103cc1 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010120f:	83 c4 10             	add    $0x10,%esp
  empty = 0;
80101212:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101217:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
8010121c:	eb 0a                	jmp    80101228 <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010121e:	85 f6                	test   %esi,%esi
80101220:	74 3b                	je     8010125d <iget+0x66>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101222:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101228:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010122e:	73 35                	jae    80101265 <iget+0x6e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101230:	8b 43 08             	mov    0x8(%ebx),%eax
80101233:	85 c0                	test   %eax,%eax
80101235:	7e e7                	jle    8010121e <iget+0x27>
80101237:	39 3b                	cmp    %edi,(%ebx)
80101239:	75 e3                	jne    8010121e <iget+0x27>
8010123b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010123e:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80101241:	75 db                	jne    8010121e <iget+0x27>
      ip->ref++;
80101243:	83 c0 01             	add    $0x1,%eax
80101246:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101249:	83 ec 0c             	sub    $0xc,%esp
8010124c:	68 60 f9 10 80       	push   $0x8010f960
80101251:	e8 d0 2a 00 00       	call   80103d26 <release>
      return ip;
80101256:	83 c4 10             	add    $0x10,%esp
80101259:	89 de                	mov    %ebx,%esi
8010125b:	eb 32                	jmp    8010128f <iget+0x98>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010125d:	85 c0                	test   %eax,%eax
8010125f:	75 c1                	jne    80101222 <iget+0x2b>
      empty = ip;
80101261:	89 de                	mov    %ebx,%esi
80101263:	eb bd                	jmp    80101222 <iget+0x2b>
  if(empty == 0)
80101265:	85 f6                	test   %esi,%esi
80101267:	74 30                	je     80101299 <iget+0xa2>
  ip->dev = dev;
80101269:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
8010126b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010126e:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
80101271:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101278:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010127f:	83 ec 0c             	sub    $0xc,%esp
80101282:	68 60 f9 10 80       	push   $0x8010f960
80101287:	e8 9a 2a 00 00       	call   80103d26 <release>
  return ip;
8010128c:	83 c4 10             	add    $0x10,%esp
}
8010128f:	89 f0                	mov    %esi,%eax
80101291:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101294:	5b                   	pop    %ebx
80101295:	5e                   	pop    %esi
80101296:	5f                   	pop    %edi
80101297:	5d                   	pop    %ebp
80101298:	c3                   	ret    
    panic("iget: no inodes");
80101299:	83 ec 0c             	sub    $0xc,%esp
8010129c:	68 1b 68 10 80       	push   $0x8010681b
801012a1:	e8 a2 f0 ff ff       	call   80100348 <panic>

801012a6 <readsb>:
{
801012a6:	55                   	push   %ebp
801012a7:	89 e5                	mov    %esp,%ebp
801012a9:	53                   	push   %ebx
801012aa:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
801012ad:	6a 01                	push   $0x1
801012af:	ff 75 08             	push   0x8(%ebp)
801012b2:	e8 b5 ee ff ff       	call   8010016c <bread>
801012b7:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801012b9:	8d 40 5c             	lea    0x5c(%eax),%eax
801012bc:	83 c4 0c             	add    $0xc,%esp
801012bf:	6a 1c                	push   $0x1c
801012c1:	50                   	push   %eax
801012c2:	ff 75 0c             	push   0xc(%ebp)
801012c5:	e8 1b 2b 00 00       	call   80103de5 <memmove>
  brelse(bp);
801012ca:	89 1c 24             	mov    %ebx,(%esp)
801012cd:	e8 03 ef ff ff       	call   801001d5 <brelse>
}
801012d2:	83 c4 10             	add    $0x10,%esp
801012d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012d8:	c9                   	leave  
801012d9:	c3                   	ret    

801012da <iinit>:
{
801012da:	55                   	push   %ebp
801012db:	89 e5                	mov    %esp,%ebp
801012dd:	53                   	push   %ebx
801012de:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801012e1:	68 2b 68 10 80       	push   $0x8010682b
801012e6:	68 60 f9 10 80       	push   $0x8010f960
801012eb:	e8 95 28 00 00       	call   80103b85 <initlock>
  for(i = 0; i < NINODE; i++) {
801012f0:	83 c4 10             	add    $0x10,%esp
801012f3:	bb 00 00 00 00       	mov    $0x0,%ebx
801012f8:	eb 21                	jmp    8010131b <iinit+0x41>
    initsleeplock(&icache.inode[i].lock, "inode");
801012fa:	83 ec 08             	sub    $0x8,%esp
801012fd:	68 32 68 10 80       	push   $0x80106832
80101302:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
80101305:	89 d0                	mov    %edx,%eax
80101307:	c1 e0 04             	shl    $0x4,%eax
8010130a:	05 a0 f9 10 80       	add    $0x8010f9a0,%eax
8010130f:	50                   	push   %eax
80101310:	e8 65 27 00 00       	call   80103a7a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101315:	83 c3 01             	add    $0x1,%ebx
80101318:	83 c4 10             	add    $0x10,%esp
8010131b:	83 fb 31             	cmp    $0x31,%ebx
8010131e:	7e da                	jle    801012fa <iinit+0x20>
  readsb(dev, &sb);
80101320:	83 ec 08             	sub    $0x8,%esp
80101323:	68 b4 15 11 80       	push   $0x801115b4
80101328:	ff 75 08             	push   0x8(%ebp)
8010132b:	e8 76 ff ff ff       	call   801012a6 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101330:	ff 35 cc 15 11 80    	push   0x801115cc
80101336:	ff 35 c8 15 11 80    	push   0x801115c8
8010133c:	ff 35 c4 15 11 80    	push   0x801115c4
80101342:	ff 35 c0 15 11 80    	push   0x801115c0
80101348:	ff 35 bc 15 11 80    	push   0x801115bc
8010134e:	ff 35 b8 15 11 80    	push   0x801115b8
80101354:	ff 35 b4 15 11 80    	push   0x801115b4
8010135a:	68 98 68 10 80       	push   $0x80106898
8010135f:	e8 a3 f2 ff ff       	call   80100607 <cprintf>
}
80101364:	83 c4 30             	add    $0x30,%esp
80101367:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010136a:	c9                   	leave  
8010136b:	c3                   	ret    

8010136c <ialloc>:
{
8010136c:	55                   	push   %ebp
8010136d:	89 e5                	mov    %esp,%ebp
8010136f:	57                   	push   %edi
80101370:	56                   	push   %esi
80101371:	53                   	push   %ebx
80101372:	83 ec 1c             	sub    $0x1c,%esp
80101375:	8b 45 0c             	mov    0xc(%ebp),%eax
80101378:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010137b:	bb 01 00 00 00       	mov    $0x1,%ebx
80101380:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101383:	39 1d bc 15 11 80    	cmp    %ebx,0x801115bc
80101389:	76 3f                	jbe    801013ca <ialloc+0x5e>
    bp = bread(dev, IBLOCK(inum, sb));
8010138b:	89 d8                	mov    %ebx,%eax
8010138d:	c1 e8 03             	shr    $0x3,%eax
80101390:	83 ec 08             	sub    $0x8,%esp
80101393:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101399:	50                   	push   %eax
8010139a:	ff 75 08             	push   0x8(%ebp)
8010139d:	e8 ca ed ff ff       	call   8010016c <bread>
801013a2:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013a4:	89 d8                	mov    %ebx,%eax
801013a6:	83 e0 07             	and    $0x7,%eax
801013a9:	c1 e0 06             	shl    $0x6,%eax
801013ac:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
801013b0:	83 c4 10             	add    $0x10,%esp
801013b3:	66 83 3f 00          	cmpw   $0x0,(%edi)
801013b7:	74 1e                	je     801013d7 <ialloc+0x6b>
    brelse(bp);
801013b9:	83 ec 0c             	sub    $0xc,%esp
801013bc:	56                   	push   %esi
801013bd:	e8 13 ee ff ff       	call   801001d5 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801013c2:	83 c3 01             	add    $0x1,%ebx
801013c5:	83 c4 10             	add    $0x10,%esp
801013c8:	eb b6                	jmp    80101380 <ialloc+0x14>
  panic("ialloc: no inodes");
801013ca:	83 ec 0c             	sub    $0xc,%esp
801013cd:	68 38 68 10 80       	push   $0x80106838
801013d2:	e8 71 ef ff ff       	call   80100348 <panic>
      memset(dip, 0, sizeof(*dip));
801013d7:	83 ec 04             	sub    $0x4,%esp
801013da:	6a 40                	push   $0x40
801013dc:	6a 00                	push   $0x0
801013de:	57                   	push   %edi
801013df:	e8 89 29 00 00       	call   80103d6d <memset>
      dip->type = type;
801013e4:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801013e8:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
801013eb:	89 34 24             	mov    %esi,(%esp)
801013ee:	e8 b4 14 00 00       	call   801028a7 <log_write>
      brelse(bp);
801013f3:	89 34 24             	mov    %esi,(%esp)
801013f6:	e8 da ed ff ff       	call   801001d5 <brelse>
      return iget(dev, inum);
801013fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101401:	e8 f1 fd ff ff       	call   801011f7 <iget>
}
80101406:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101409:	5b                   	pop    %ebx
8010140a:	5e                   	pop    %esi
8010140b:	5f                   	pop    %edi
8010140c:	5d                   	pop    %ebp
8010140d:	c3                   	ret    

8010140e <iupdate>:
{
8010140e:	55                   	push   %ebp
8010140f:	89 e5                	mov    %esp,%ebp
80101411:	56                   	push   %esi
80101412:	53                   	push   %ebx
80101413:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101416:	8b 43 04             	mov    0x4(%ebx),%eax
80101419:	c1 e8 03             	shr    $0x3,%eax
8010141c:	83 ec 08             	sub    $0x8,%esp
8010141f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101425:	50                   	push   %eax
80101426:	ff 33                	push   (%ebx)
80101428:	e8 3f ed ff ff       	call   8010016c <bread>
8010142d:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010142f:	8b 43 04             	mov    0x4(%ebx),%eax
80101432:	83 e0 07             	and    $0x7,%eax
80101435:	c1 e0 06             	shl    $0x6,%eax
80101438:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010143c:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
80101440:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101443:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
80101447:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010144b:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
8010144f:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101453:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
80101457:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010145b:	8b 53 58             	mov    0x58(%ebx),%edx
8010145e:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101461:	83 c3 5c             	add    $0x5c,%ebx
80101464:	83 c0 0c             	add    $0xc,%eax
80101467:	83 c4 0c             	add    $0xc,%esp
8010146a:	6a 34                	push   $0x34
8010146c:	53                   	push   %ebx
8010146d:	50                   	push   %eax
8010146e:	e8 72 29 00 00       	call   80103de5 <memmove>
  log_write(bp);
80101473:	89 34 24             	mov    %esi,(%esp)
80101476:	e8 2c 14 00 00       	call   801028a7 <log_write>
  brelse(bp);
8010147b:	89 34 24             	mov    %esi,(%esp)
8010147e:	e8 52 ed ff ff       	call   801001d5 <brelse>
}
80101483:	83 c4 10             	add    $0x10,%esp
80101486:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101489:	5b                   	pop    %ebx
8010148a:	5e                   	pop    %esi
8010148b:	5d                   	pop    %ebp
8010148c:	c3                   	ret    

8010148d <itrunc>:
{
8010148d:	55                   	push   %ebp
8010148e:	89 e5                	mov    %esp,%ebp
80101490:	57                   	push   %edi
80101491:	56                   	push   %esi
80101492:	53                   	push   %ebx
80101493:	83 ec 1c             	sub    $0x1c,%esp
80101496:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
80101498:	bb 00 00 00 00       	mov    $0x0,%ebx
8010149d:	eb 03                	jmp    801014a2 <itrunc+0x15>
8010149f:	83 c3 01             	add    $0x1,%ebx
801014a2:	83 fb 0b             	cmp    $0xb,%ebx
801014a5:	7f 19                	jg     801014c0 <itrunc+0x33>
    if(ip->addrs[i]){
801014a7:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
801014ab:	85 d2                	test   %edx,%edx
801014ad:	74 f0                	je     8010149f <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
801014af:	8b 06                	mov    (%esi),%eax
801014b1:	e8 3d fb ff ff       	call   80100ff3 <bfree>
      ip->addrs[i] = 0;
801014b6:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
801014bd:	00 
801014be:	eb df                	jmp    8010149f <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
801014c0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801014c6:	85 c0                	test   %eax,%eax
801014c8:	75 1b                	jne    801014e5 <itrunc+0x58>
  ip->size = 0;
801014ca:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801014d1:	83 ec 0c             	sub    $0xc,%esp
801014d4:	56                   	push   %esi
801014d5:	e8 34 ff ff ff       	call   8010140e <iupdate>
}
801014da:	83 c4 10             	add    $0x10,%esp
801014dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e0:	5b                   	pop    %ebx
801014e1:	5e                   	pop    %esi
801014e2:	5f                   	pop    %edi
801014e3:	5d                   	pop    %ebp
801014e4:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801014e5:	83 ec 08             	sub    $0x8,%esp
801014e8:	50                   	push   %eax
801014e9:	ff 36                	push   (%esi)
801014eb:	e8 7c ec ff ff       	call   8010016c <bread>
801014f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801014f3:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
801014f6:	83 c4 10             	add    $0x10,%esp
801014f9:	bb 00 00 00 00       	mov    $0x0,%ebx
801014fe:	eb 03                	jmp    80101503 <itrunc+0x76>
80101500:	83 c3 01             	add    $0x1,%ebx
80101503:	83 fb 7f             	cmp    $0x7f,%ebx
80101506:	77 10                	ja     80101518 <itrunc+0x8b>
      if(a[j])
80101508:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
8010150b:	85 d2                	test   %edx,%edx
8010150d:	74 f1                	je     80101500 <itrunc+0x73>
        bfree(ip->dev, a[j]);
8010150f:	8b 06                	mov    (%esi),%eax
80101511:	e8 dd fa ff ff       	call   80100ff3 <bfree>
80101516:	eb e8                	jmp    80101500 <itrunc+0x73>
    brelse(bp);
80101518:	83 ec 0c             	sub    $0xc,%esp
8010151b:	ff 75 e4             	push   -0x1c(%ebp)
8010151e:	e8 b2 ec ff ff       	call   801001d5 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101523:	8b 06                	mov    (%esi),%eax
80101525:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
8010152b:	e8 c3 fa ff ff       	call   80100ff3 <bfree>
    ip->addrs[NDIRECT] = 0;
80101530:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101537:	00 00 00 
8010153a:	83 c4 10             	add    $0x10,%esp
8010153d:	eb 8b                	jmp    801014ca <itrunc+0x3d>

8010153f <idup>:
{
8010153f:	55                   	push   %ebp
80101540:	89 e5                	mov    %esp,%ebp
80101542:	53                   	push   %ebx
80101543:	83 ec 10             	sub    $0x10,%esp
80101546:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101549:	68 60 f9 10 80       	push   $0x8010f960
8010154e:	e8 6e 27 00 00       	call   80103cc1 <acquire>
  ip->ref++;
80101553:	8b 43 08             	mov    0x8(%ebx),%eax
80101556:	83 c0 01             	add    $0x1,%eax
80101559:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
8010155c:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101563:	e8 be 27 00 00       	call   80103d26 <release>
}
80101568:	89 d8                	mov    %ebx,%eax
8010156a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010156d:	c9                   	leave  
8010156e:	c3                   	ret    

8010156f <ilock>:
{
8010156f:	55                   	push   %ebp
80101570:	89 e5                	mov    %esp,%ebp
80101572:	56                   	push   %esi
80101573:	53                   	push   %ebx
80101574:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101577:	85 db                	test   %ebx,%ebx
80101579:	74 22                	je     8010159d <ilock+0x2e>
8010157b:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
8010157f:	7e 1c                	jle    8010159d <ilock+0x2e>
  acquiresleep(&ip->lock);
80101581:	83 ec 0c             	sub    $0xc,%esp
80101584:	8d 43 0c             	lea    0xc(%ebx),%eax
80101587:	50                   	push   %eax
80101588:	e8 20 25 00 00       	call   80103aad <acquiresleep>
  if(ip->valid == 0){
8010158d:	83 c4 10             	add    $0x10,%esp
80101590:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101594:	74 14                	je     801015aa <ilock+0x3b>
}
80101596:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101599:	5b                   	pop    %ebx
8010159a:	5e                   	pop    %esi
8010159b:	5d                   	pop    %ebp
8010159c:	c3                   	ret    
    panic("ilock");
8010159d:	83 ec 0c             	sub    $0xc,%esp
801015a0:	68 4a 68 10 80       	push   $0x8010684a
801015a5:	e8 9e ed ff ff       	call   80100348 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015aa:	8b 43 04             	mov    0x4(%ebx),%eax
801015ad:	c1 e8 03             	shr    $0x3,%eax
801015b0:	83 ec 08             	sub    $0x8,%esp
801015b3:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801015b9:	50                   	push   %eax
801015ba:	ff 33                	push   (%ebx)
801015bc:	e8 ab eb ff ff       	call   8010016c <bread>
801015c1:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801015c3:	8b 43 04             	mov    0x4(%ebx),%eax
801015c6:	83 e0 07             	and    $0x7,%eax
801015c9:	c1 e0 06             	shl    $0x6,%eax
801015cc:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801015d0:	0f b7 10             	movzwl (%eax),%edx
801015d3:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801015d7:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801015db:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801015df:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801015e3:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801015e7:	0f b7 50 06          	movzwl 0x6(%eax),%edx
801015eb:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801015ef:	8b 50 08             	mov    0x8(%eax),%edx
801015f2:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801015f5:	83 c0 0c             	add    $0xc,%eax
801015f8:	8d 53 5c             	lea    0x5c(%ebx),%edx
801015fb:	83 c4 0c             	add    $0xc,%esp
801015fe:	6a 34                	push   $0x34
80101600:	50                   	push   %eax
80101601:	52                   	push   %edx
80101602:	e8 de 27 00 00       	call   80103de5 <memmove>
    brelse(bp);
80101607:	89 34 24             	mov    %esi,(%esp)
8010160a:	e8 c6 eb ff ff       	call   801001d5 <brelse>
    ip->valid = 1;
8010160f:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101616:	83 c4 10             	add    $0x10,%esp
80101619:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010161e:	0f 85 72 ff ff ff    	jne    80101596 <ilock+0x27>
      panic("ilock: no type");
80101624:	83 ec 0c             	sub    $0xc,%esp
80101627:	68 50 68 10 80       	push   $0x80106850
8010162c:	e8 17 ed ff ff       	call   80100348 <panic>

80101631 <iunlock>:
{
80101631:	55                   	push   %ebp
80101632:	89 e5                	mov    %esp,%ebp
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101639:	85 db                	test   %ebx,%ebx
8010163b:	74 2c                	je     80101669 <iunlock+0x38>
8010163d:	8d 73 0c             	lea    0xc(%ebx),%esi
80101640:	83 ec 0c             	sub    $0xc,%esp
80101643:	56                   	push   %esi
80101644:	e8 ee 24 00 00       	call   80103b37 <holdingsleep>
80101649:	83 c4 10             	add    $0x10,%esp
8010164c:	85 c0                	test   %eax,%eax
8010164e:	74 19                	je     80101669 <iunlock+0x38>
80101650:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101654:	7e 13                	jle    80101669 <iunlock+0x38>
  releasesleep(&ip->lock);
80101656:	83 ec 0c             	sub    $0xc,%esp
80101659:	56                   	push   %esi
8010165a:	e8 9d 24 00 00       	call   80103afc <releasesleep>
}
8010165f:	83 c4 10             	add    $0x10,%esp
80101662:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101665:	5b                   	pop    %ebx
80101666:	5e                   	pop    %esi
80101667:	5d                   	pop    %ebp
80101668:	c3                   	ret    
    panic("iunlock");
80101669:	83 ec 0c             	sub    $0xc,%esp
8010166c:	68 5f 68 10 80       	push   $0x8010685f
80101671:	e8 d2 ec ff ff       	call   80100348 <panic>

80101676 <iput>:
{
80101676:	55                   	push   %ebp
80101677:	89 e5                	mov    %esp,%ebp
80101679:	57                   	push   %edi
8010167a:	56                   	push   %esi
8010167b:	53                   	push   %ebx
8010167c:	83 ec 18             	sub    $0x18,%esp
8010167f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101682:	8d 73 0c             	lea    0xc(%ebx),%esi
80101685:	56                   	push   %esi
80101686:	e8 22 24 00 00       	call   80103aad <acquiresleep>
  if(ip->valid && ip->nlink == 0){
8010168b:	83 c4 10             	add    $0x10,%esp
8010168e:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101692:	74 07                	je     8010169b <iput+0x25>
80101694:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101699:	74 35                	je     801016d0 <iput+0x5a>
  releasesleep(&ip->lock);
8010169b:	83 ec 0c             	sub    $0xc,%esp
8010169e:	56                   	push   %esi
8010169f:	e8 58 24 00 00       	call   80103afc <releasesleep>
  acquire(&icache.lock);
801016a4:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801016ab:	e8 11 26 00 00       	call   80103cc1 <acquire>
  ip->ref--;
801016b0:	8b 43 08             	mov    0x8(%ebx),%eax
801016b3:	83 e8 01             	sub    $0x1,%eax
801016b6:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801016b9:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801016c0:	e8 61 26 00 00       	call   80103d26 <release>
}
801016c5:	83 c4 10             	add    $0x10,%esp
801016c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016cb:	5b                   	pop    %ebx
801016cc:	5e                   	pop    %esi
801016cd:	5f                   	pop    %edi
801016ce:	5d                   	pop    %ebp
801016cf:	c3                   	ret    
    acquire(&icache.lock);
801016d0:	83 ec 0c             	sub    $0xc,%esp
801016d3:	68 60 f9 10 80       	push   $0x8010f960
801016d8:	e8 e4 25 00 00       	call   80103cc1 <acquire>
    int r = ip->ref;
801016dd:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
801016e0:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801016e7:	e8 3a 26 00 00       	call   80103d26 <release>
    if(r == 1){
801016ec:	83 c4 10             	add    $0x10,%esp
801016ef:	83 ff 01             	cmp    $0x1,%edi
801016f2:	75 a7                	jne    8010169b <iput+0x25>
      itrunc(ip);
801016f4:	89 d8                	mov    %ebx,%eax
801016f6:	e8 92 fd ff ff       	call   8010148d <itrunc>
      ip->type = 0;
801016fb:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101701:	83 ec 0c             	sub    $0xc,%esp
80101704:	53                   	push   %ebx
80101705:	e8 04 fd ff ff       	call   8010140e <iupdate>
      ip->valid = 0;
8010170a:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101711:	83 c4 10             	add    $0x10,%esp
80101714:	eb 85                	jmp    8010169b <iput+0x25>

80101716 <iunlockput>:
{
80101716:	55                   	push   %ebp
80101717:	89 e5                	mov    %esp,%ebp
80101719:	53                   	push   %ebx
8010171a:	83 ec 10             	sub    $0x10,%esp
8010171d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101720:	53                   	push   %ebx
80101721:	e8 0b ff ff ff       	call   80101631 <iunlock>
  iput(ip);
80101726:	89 1c 24             	mov    %ebx,(%esp)
80101729:	e8 48 ff ff ff       	call   80101676 <iput>
}
8010172e:	83 c4 10             	add    $0x10,%esp
80101731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101734:	c9                   	leave  
80101735:	c3                   	ret    

80101736 <stati>:
{
80101736:	55                   	push   %ebp
80101737:	89 e5                	mov    %esp,%ebp
80101739:	8b 55 08             	mov    0x8(%ebp),%edx
8010173c:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
8010173f:	8b 0a                	mov    (%edx),%ecx
80101741:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101744:	8b 4a 04             	mov    0x4(%edx),%ecx
80101747:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
8010174a:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
8010174e:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101751:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101755:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101759:	8b 52 58             	mov    0x58(%edx),%edx
8010175c:	89 50 10             	mov    %edx,0x10(%eax)
}
8010175f:	5d                   	pop    %ebp
80101760:	c3                   	ret    

80101761 <readi>:
{
80101761:	55                   	push   %ebp
80101762:	89 e5                	mov    %esp,%ebp
80101764:	57                   	push   %edi
80101765:	56                   	push   %esi
80101766:	53                   	push   %ebx
80101767:	83 ec 1c             	sub    $0x1c,%esp
8010176a:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
8010176d:	8b 45 08             	mov    0x8(%ebp),%eax
80101770:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101775:	74 2c                	je     801017a3 <readi+0x42>
  if(off > ip->size || off + n < off)
80101777:	8b 45 08             	mov    0x8(%ebp),%eax
8010177a:	8b 40 58             	mov    0x58(%eax),%eax
8010177d:	39 f8                	cmp    %edi,%eax
8010177f:	0f 82 cb 00 00 00    	jb     80101850 <readi+0xef>
80101785:	89 fa                	mov    %edi,%edx
80101787:	03 55 14             	add    0x14(%ebp),%edx
8010178a:	0f 82 c7 00 00 00    	jb     80101857 <readi+0xf6>
  if(off + n > ip->size)
80101790:	39 d0                	cmp    %edx,%eax
80101792:	73 05                	jae    80101799 <readi+0x38>
    n = ip->size - off;
80101794:	29 f8                	sub    %edi,%eax
80101796:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101799:	be 00 00 00 00       	mov    $0x0,%esi
8010179e:	e9 8f 00 00 00       	jmp    80101832 <readi+0xd1>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801017a3:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801017a7:	66 83 f8 09          	cmp    $0x9,%ax
801017ab:	0f 87 91 00 00 00    	ja     80101842 <readi+0xe1>
801017b1:	98                   	cwtl   
801017b2:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
801017b9:	85 c0                	test   %eax,%eax
801017bb:	0f 84 88 00 00 00    	je     80101849 <readi+0xe8>
    return devsw[ip->major].read(ip, dst, n);
801017c1:	83 ec 04             	sub    $0x4,%esp
801017c4:	ff 75 14             	push   0x14(%ebp)
801017c7:	ff 75 0c             	push   0xc(%ebp)
801017ca:	ff 75 08             	push   0x8(%ebp)
801017cd:	ff d0                	call   *%eax
801017cf:	83 c4 10             	add    $0x10,%esp
801017d2:	eb 66                	jmp    8010183a <readi+0xd9>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801017d4:	89 fa                	mov    %edi,%edx
801017d6:	c1 ea 09             	shr    $0x9,%edx
801017d9:	8b 45 08             	mov    0x8(%ebp),%eax
801017dc:	e8 70 f9 ff ff       	call   80101151 <bmap>
801017e1:	83 ec 08             	sub    $0x8,%esp
801017e4:	50                   	push   %eax
801017e5:	8b 45 08             	mov    0x8(%ebp),%eax
801017e8:	ff 30                	push   (%eax)
801017ea:	e8 7d e9 ff ff       	call   8010016c <bread>
801017ef:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
801017f1:	89 f8                	mov    %edi,%eax
801017f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801017f8:	bb 00 02 00 00       	mov    $0x200,%ebx
801017fd:	29 c3                	sub    %eax,%ebx
801017ff:	8b 55 14             	mov    0x14(%ebp),%edx
80101802:	29 f2                	sub    %esi,%edx
80101804:	39 d3                	cmp    %edx,%ebx
80101806:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101809:	83 c4 0c             	add    $0xc,%esp
8010180c:	53                   	push   %ebx
8010180d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101810:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101814:	50                   	push   %eax
80101815:	ff 75 0c             	push   0xc(%ebp)
80101818:	e8 c8 25 00 00       	call   80103de5 <memmove>
    brelse(bp);
8010181d:	83 c4 04             	add    $0x4,%esp
80101820:	ff 75 e4             	push   -0x1c(%ebp)
80101823:	e8 ad e9 ff ff       	call   801001d5 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101828:	01 de                	add    %ebx,%esi
8010182a:	01 df                	add    %ebx,%edi
8010182c:	01 5d 0c             	add    %ebx,0xc(%ebp)
8010182f:	83 c4 10             	add    $0x10,%esp
80101832:	39 75 14             	cmp    %esi,0x14(%ebp)
80101835:	77 9d                	ja     801017d4 <readi+0x73>
  return n;
80101837:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010183a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010183d:	5b                   	pop    %ebx
8010183e:	5e                   	pop    %esi
8010183f:	5f                   	pop    %edi
80101840:	5d                   	pop    %ebp
80101841:	c3                   	ret    
      return -1;
80101842:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101847:	eb f1                	jmp    8010183a <readi+0xd9>
80101849:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010184e:	eb ea                	jmp    8010183a <readi+0xd9>
    return -1;
80101850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101855:	eb e3                	jmp    8010183a <readi+0xd9>
80101857:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010185c:	eb dc                	jmp    8010183a <readi+0xd9>

8010185e <writei>:
{
8010185e:	55                   	push   %ebp
8010185f:	89 e5                	mov    %esp,%ebp
80101861:	57                   	push   %edi
80101862:	56                   	push   %esi
80101863:	53                   	push   %ebx
80101864:	83 ec 1c             	sub    $0x1c,%esp
80101867:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
8010186a:	8b 45 08             	mov    0x8(%ebp),%eax
8010186d:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101872:	74 2e                	je     801018a2 <writei+0x44>
  if(off > ip->size || off + n < off)
80101874:	8b 45 08             	mov    0x8(%ebp),%eax
80101877:	39 78 58             	cmp    %edi,0x58(%eax)
8010187a:	0f 82 f5 00 00 00    	jb     80101975 <writei+0x117>
80101880:	89 f8                	mov    %edi,%eax
80101882:	03 45 14             	add    0x14(%ebp),%eax
80101885:	0f 82 f1 00 00 00    	jb     8010197c <writei+0x11e>
  if(off + n > MAXFILE*BSIZE)
8010188b:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101890:	0f 87 ed 00 00 00    	ja     80101983 <writei+0x125>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101896:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010189d:	e9 93 00 00 00       	jmp    80101935 <writei+0xd7>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801018a2:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801018a6:	66 83 f8 09          	cmp    $0x9,%ax
801018aa:	0f 87 b7 00 00 00    	ja     80101967 <writei+0x109>
801018b0:	98                   	cwtl   
801018b1:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
801018b8:	85 c0                	test   %eax,%eax
801018ba:	0f 84 ae 00 00 00    	je     8010196e <writei+0x110>
    return devsw[ip->major].write(ip, src, n);
801018c0:	83 ec 04             	sub    $0x4,%esp
801018c3:	ff 75 14             	push   0x14(%ebp)
801018c6:	ff 75 0c             	push   0xc(%ebp)
801018c9:	ff 75 08             	push   0x8(%ebp)
801018cc:	ff d0                	call   *%eax
801018ce:	83 c4 10             	add    $0x10,%esp
801018d1:	eb 7b                	jmp    8010194e <writei+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801018d3:	89 fa                	mov    %edi,%edx
801018d5:	c1 ea 09             	shr    $0x9,%edx
801018d8:	8b 45 08             	mov    0x8(%ebp),%eax
801018db:	e8 71 f8 ff ff       	call   80101151 <bmap>
801018e0:	83 ec 08             	sub    $0x8,%esp
801018e3:	50                   	push   %eax
801018e4:	8b 45 08             	mov    0x8(%ebp),%eax
801018e7:	ff 30                	push   (%eax)
801018e9:	e8 7e e8 ff ff       	call   8010016c <bread>
801018ee:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
801018f0:	89 f8                	mov    %edi,%eax
801018f2:	25 ff 01 00 00       	and    $0x1ff,%eax
801018f7:	bb 00 02 00 00       	mov    $0x200,%ebx
801018fc:	29 c3                	sub    %eax,%ebx
801018fe:	8b 55 14             	mov    0x14(%ebp),%edx
80101901:	2b 55 e4             	sub    -0x1c(%ebp),%edx
80101904:	39 d3                	cmp    %edx,%ebx
80101906:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101909:	83 c4 0c             	add    $0xc,%esp
8010190c:	53                   	push   %ebx
8010190d:	ff 75 0c             	push   0xc(%ebp)
80101910:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
80101914:	50                   	push   %eax
80101915:	e8 cb 24 00 00       	call   80103de5 <memmove>
    log_write(bp);
8010191a:	89 34 24             	mov    %esi,(%esp)
8010191d:	e8 85 0f 00 00       	call   801028a7 <log_write>
    brelse(bp);
80101922:	89 34 24             	mov    %esi,(%esp)
80101925:	e8 ab e8 ff ff       	call   801001d5 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010192a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010192d:	01 df                	add    %ebx,%edi
8010192f:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101932:	83 c4 10             	add    $0x10,%esp
80101935:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101938:	3b 45 14             	cmp    0x14(%ebp),%eax
8010193b:	72 96                	jb     801018d3 <writei+0x75>
  if(n > 0 && off > ip->size){
8010193d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80101941:	74 08                	je     8010194b <writei+0xed>
80101943:	8b 45 08             	mov    0x8(%ebp),%eax
80101946:	39 78 58             	cmp    %edi,0x58(%eax)
80101949:	72 0b                	jb     80101956 <writei+0xf8>
  return n;
8010194b:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010194e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101951:	5b                   	pop    %ebx
80101952:	5e                   	pop    %esi
80101953:	5f                   	pop    %edi
80101954:	5d                   	pop    %ebp
80101955:	c3                   	ret    
    ip->size = off;
80101956:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101959:	83 ec 0c             	sub    $0xc,%esp
8010195c:	50                   	push   %eax
8010195d:	e8 ac fa ff ff       	call   8010140e <iupdate>
80101962:	83 c4 10             	add    $0x10,%esp
80101965:	eb e4                	jmp    8010194b <writei+0xed>
      return -1;
80101967:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010196c:	eb e0                	jmp    8010194e <writei+0xf0>
8010196e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101973:	eb d9                	jmp    8010194e <writei+0xf0>
    return -1;
80101975:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010197a:	eb d2                	jmp    8010194e <writei+0xf0>
8010197c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101981:	eb cb                	jmp    8010194e <writei+0xf0>
    return -1;
80101983:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101988:	eb c4                	jmp    8010194e <writei+0xf0>

8010198a <namecmp>:
{
8010198a:	55                   	push   %ebp
8010198b:	89 e5                	mov    %esp,%ebp
8010198d:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101990:	6a 0e                	push   $0xe
80101992:	ff 75 0c             	push   0xc(%ebp)
80101995:	ff 75 08             	push   0x8(%ebp)
80101998:	e8 b4 24 00 00       	call   80103e51 <strncmp>
}
8010199d:	c9                   	leave  
8010199e:	c3                   	ret    

8010199f <dirlookup>:
{
8010199f:	55                   	push   %ebp
801019a0:	89 e5                	mov    %esp,%ebp
801019a2:	57                   	push   %edi
801019a3:	56                   	push   %esi
801019a4:	53                   	push   %ebx
801019a5:	83 ec 1c             	sub    $0x1c,%esp
801019a8:	8b 75 08             	mov    0x8(%ebp),%esi
801019ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
801019ae:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801019b3:	75 07                	jne    801019bc <dirlookup+0x1d>
  for(off = 0; off < dp->size; off += sizeof(de)){
801019b5:	bb 00 00 00 00       	mov    $0x0,%ebx
801019ba:	eb 1d                	jmp    801019d9 <dirlookup+0x3a>
    panic("dirlookup not DIR");
801019bc:	83 ec 0c             	sub    $0xc,%esp
801019bf:	68 67 68 10 80       	push   $0x80106867
801019c4:	e8 7f e9 ff ff       	call   80100348 <panic>
      panic("dirlookup read");
801019c9:	83 ec 0c             	sub    $0xc,%esp
801019cc:	68 79 68 10 80       	push   $0x80106879
801019d1:	e8 72 e9 ff ff       	call   80100348 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
801019d6:	83 c3 10             	add    $0x10,%ebx
801019d9:	39 5e 58             	cmp    %ebx,0x58(%esi)
801019dc:	76 48                	jbe    80101a26 <dirlookup+0x87>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801019de:	6a 10                	push   $0x10
801019e0:	53                   	push   %ebx
801019e1:	8d 45 d8             	lea    -0x28(%ebp),%eax
801019e4:	50                   	push   %eax
801019e5:	56                   	push   %esi
801019e6:	e8 76 fd ff ff       	call   80101761 <readi>
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	83 f8 10             	cmp    $0x10,%eax
801019f1:	75 d6                	jne    801019c9 <dirlookup+0x2a>
    if(de.inum == 0)
801019f3:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801019f8:	74 dc                	je     801019d6 <dirlookup+0x37>
    if(namecmp(name, de.name) == 0){
801019fa:	83 ec 08             	sub    $0x8,%esp
801019fd:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a00:	50                   	push   %eax
80101a01:	57                   	push   %edi
80101a02:	e8 83 ff ff ff       	call   8010198a <namecmp>
80101a07:	83 c4 10             	add    $0x10,%esp
80101a0a:	85 c0                	test   %eax,%eax
80101a0c:	75 c8                	jne    801019d6 <dirlookup+0x37>
      if(poff)
80101a0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a12:	74 05                	je     80101a19 <dirlookup+0x7a>
        *poff = off;
80101a14:	8b 45 10             	mov    0x10(%ebp),%eax
80101a17:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a19:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a1d:	8b 06                	mov    (%esi),%eax
80101a1f:	e8 d3 f7 ff ff       	call   801011f7 <iget>
80101a24:	eb 05                	jmp    80101a2b <dirlookup+0x8c>
  return 0;
80101a26:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101a2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a2e:	5b                   	pop    %ebx
80101a2f:	5e                   	pop    %esi
80101a30:	5f                   	pop    %edi
80101a31:	5d                   	pop    %ebp
80101a32:	c3                   	ret    

80101a33 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a33:	55                   	push   %ebp
80101a34:	89 e5                	mov    %esp,%ebp
80101a36:	57                   	push   %edi
80101a37:	56                   	push   %esi
80101a38:	53                   	push   %ebx
80101a39:	83 ec 1c             	sub    $0x1c,%esp
80101a3c:	89 c3                	mov    %eax,%ebx
80101a3e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101a41:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a44:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a47:	74 17                	je     80101a60 <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101a49:	e8 74 17 00 00       	call   801031c2 <myproc>
80101a4e:	83 ec 0c             	sub    $0xc,%esp
80101a51:	ff 70 68             	push   0x68(%eax)
80101a54:	e8 e6 fa ff ff       	call   8010153f <idup>
80101a59:	89 c6                	mov    %eax,%esi
80101a5b:	83 c4 10             	add    $0x10,%esp
80101a5e:	eb 53                	jmp    80101ab3 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101a60:	ba 01 00 00 00       	mov    $0x1,%edx
80101a65:	b8 01 00 00 00       	mov    $0x1,%eax
80101a6a:	e8 88 f7 ff ff       	call   801011f7 <iget>
80101a6f:	89 c6                	mov    %eax,%esi
80101a71:	eb 40                	jmp    80101ab3 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101a73:	83 ec 0c             	sub    $0xc,%esp
80101a76:	56                   	push   %esi
80101a77:	e8 9a fc ff ff       	call   80101716 <iunlockput>
      return 0;
80101a7c:	83 c4 10             	add    $0x10,%esp
80101a7f:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101a84:	89 f0                	mov    %esi,%eax
80101a86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a89:	5b                   	pop    %ebx
80101a8a:	5e                   	pop    %esi
80101a8b:	5f                   	pop    %edi
80101a8c:	5d                   	pop    %ebp
80101a8d:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101a8e:	83 ec 04             	sub    $0x4,%esp
80101a91:	6a 00                	push   $0x0
80101a93:	ff 75 e4             	push   -0x1c(%ebp)
80101a96:	56                   	push   %esi
80101a97:	e8 03 ff ff ff       	call   8010199f <dirlookup>
80101a9c:	89 c7                	mov    %eax,%edi
80101a9e:	83 c4 10             	add    $0x10,%esp
80101aa1:	85 c0                	test   %eax,%eax
80101aa3:	74 4a                	je     80101aef <namex+0xbc>
    iunlockput(ip);
80101aa5:	83 ec 0c             	sub    $0xc,%esp
80101aa8:	56                   	push   %esi
80101aa9:	e8 68 fc ff ff       	call   80101716 <iunlockput>
80101aae:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101ab1:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101ab3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ab6:	89 d8                	mov    %ebx,%eax
80101ab8:	e8 85 f4 ff ff       	call   80100f42 <skipelem>
80101abd:	89 c3                	mov    %eax,%ebx
80101abf:	85 c0                	test   %eax,%eax
80101ac1:	74 3c                	je     80101aff <namex+0xcc>
    ilock(ip);
80101ac3:	83 ec 0c             	sub    $0xc,%esp
80101ac6:	56                   	push   %esi
80101ac7:	e8 a3 fa ff ff       	call   8010156f <ilock>
    if(ip->type != T_DIR){
80101acc:	83 c4 10             	add    $0x10,%esp
80101acf:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ad4:	75 9d                	jne    80101a73 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101ad6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101ada:	74 b2                	je     80101a8e <namex+0x5b>
80101adc:	80 3b 00             	cmpb   $0x0,(%ebx)
80101adf:	75 ad                	jne    80101a8e <namex+0x5b>
      iunlock(ip);
80101ae1:	83 ec 0c             	sub    $0xc,%esp
80101ae4:	56                   	push   %esi
80101ae5:	e8 47 fb ff ff       	call   80101631 <iunlock>
      return ip;
80101aea:	83 c4 10             	add    $0x10,%esp
80101aed:	eb 95                	jmp    80101a84 <namex+0x51>
      iunlockput(ip);
80101aef:	83 ec 0c             	sub    $0xc,%esp
80101af2:	56                   	push   %esi
80101af3:	e8 1e fc ff ff       	call   80101716 <iunlockput>
      return 0;
80101af8:	83 c4 10             	add    $0x10,%esp
80101afb:	89 fe                	mov    %edi,%esi
80101afd:	eb 85                	jmp    80101a84 <namex+0x51>
  if(nameiparent){
80101aff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b03:	0f 84 7b ff ff ff    	je     80101a84 <namex+0x51>
    iput(ip);
80101b09:	83 ec 0c             	sub    $0xc,%esp
80101b0c:	56                   	push   %esi
80101b0d:	e8 64 fb ff ff       	call   80101676 <iput>
    return 0;
80101b12:	83 c4 10             	add    $0x10,%esp
80101b15:	89 de                	mov    %ebx,%esi
80101b17:	e9 68 ff ff ff       	jmp    80101a84 <namex+0x51>

80101b1c <dirlink>:
{
80101b1c:	55                   	push   %ebp
80101b1d:	89 e5                	mov    %esp,%ebp
80101b1f:	57                   	push   %edi
80101b20:	56                   	push   %esi
80101b21:	53                   	push   %ebx
80101b22:	83 ec 20             	sub    $0x20,%esp
80101b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101b28:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101b2b:	6a 00                	push   $0x0
80101b2d:	57                   	push   %edi
80101b2e:	53                   	push   %ebx
80101b2f:	e8 6b fe ff ff       	call   8010199f <dirlookup>
80101b34:	83 c4 10             	add    $0x10,%esp
80101b37:	85 c0                	test   %eax,%eax
80101b39:	75 2d                	jne    80101b68 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b3b:	b8 00 00 00 00       	mov    $0x0,%eax
80101b40:	89 c6                	mov    %eax,%esi
80101b42:	39 43 58             	cmp    %eax,0x58(%ebx)
80101b45:	76 41                	jbe    80101b88 <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b47:	6a 10                	push   $0x10
80101b49:	50                   	push   %eax
80101b4a:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101b4d:	50                   	push   %eax
80101b4e:	53                   	push   %ebx
80101b4f:	e8 0d fc ff ff       	call   80101761 <readi>
80101b54:	83 c4 10             	add    $0x10,%esp
80101b57:	83 f8 10             	cmp    $0x10,%eax
80101b5a:	75 1f                	jne    80101b7b <dirlink+0x5f>
    if(de.inum == 0)
80101b5c:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101b61:	74 25                	je     80101b88 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b63:	8d 46 10             	lea    0x10(%esi),%eax
80101b66:	eb d8                	jmp    80101b40 <dirlink+0x24>
    iput(ip);
80101b68:	83 ec 0c             	sub    $0xc,%esp
80101b6b:	50                   	push   %eax
80101b6c:	e8 05 fb ff ff       	call   80101676 <iput>
    return -1;
80101b71:	83 c4 10             	add    $0x10,%esp
80101b74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b79:	eb 3d                	jmp    80101bb8 <dirlink+0x9c>
      panic("dirlink read");
80101b7b:	83 ec 0c             	sub    $0xc,%esp
80101b7e:	68 88 68 10 80       	push   $0x80106888
80101b83:	e8 c0 e7 ff ff       	call   80100348 <panic>
  strncpy(de.name, name, DIRSIZ);
80101b88:	83 ec 04             	sub    $0x4,%esp
80101b8b:	6a 0e                	push   $0xe
80101b8d:	57                   	push   %edi
80101b8e:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101b91:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b94:	50                   	push   %eax
80101b95:	e8 f6 22 00 00       	call   80103e90 <strncpy>
  de.inum = inum;
80101b9a:	8b 45 10             	mov    0x10(%ebp),%eax
80101b9d:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ba1:	6a 10                	push   $0x10
80101ba3:	56                   	push   %esi
80101ba4:	57                   	push   %edi
80101ba5:	53                   	push   %ebx
80101ba6:	e8 b3 fc ff ff       	call   8010185e <writei>
80101bab:	83 c4 20             	add    $0x20,%esp
80101bae:	83 f8 10             	cmp    $0x10,%eax
80101bb1:	75 0d                	jne    80101bc0 <dirlink+0xa4>
  return 0;
80101bb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bbb:	5b                   	pop    %ebx
80101bbc:	5e                   	pop    %esi
80101bbd:	5f                   	pop    %edi
80101bbe:	5d                   	pop    %ebp
80101bbf:	c3                   	ret    
    panic("dirlink");
80101bc0:	83 ec 0c             	sub    $0xc,%esp
80101bc3:	68 80 6e 10 80       	push   $0x80106e80
80101bc8:	e8 7b e7 ff ff       	call   80100348 <panic>

80101bcd <namei>:

struct inode*
namei(char *path)
{
80101bcd:	55                   	push   %ebp
80101bce:	89 e5                	mov    %esp,%ebp
80101bd0:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101bd3:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101bd6:	ba 00 00 00 00       	mov    $0x0,%edx
80101bdb:	8b 45 08             	mov    0x8(%ebp),%eax
80101bde:	e8 50 fe ff ff       	call   80101a33 <namex>
}
80101be3:	c9                   	leave  
80101be4:	c3                   	ret    

80101be5 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101be5:	55                   	push   %ebp
80101be6:	89 e5                	mov    %esp,%ebp
80101be8:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101beb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101bee:	ba 01 00 00 00       	mov    $0x1,%edx
80101bf3:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf6:	e8 38 fe ff ff       	call   80101a33 <namex>
}
80101bfb:	c9                   	leave  
80101bfc:	c3                   	ret    

80101bfd <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101bfd:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101bff:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c04:	ec                   	in     (%dx),%al
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101c05:	89 c2                	mov    %eax,%edx
80101c07:	83 e2 c0             	and    $0xffffffc0,%edx
80101c0a:	80 fa 40             	cmp    $0x40,%dl
80101c0d:	75 f0                	jne    80101bff <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101c0f:	85 c9                	test   %ecx,%ecx
80101c11:	74 09                	je     80101c1c <idewait+0x1f>
80101c13:	a8 21                	test   $0x21,%al
80101c15:	75 08                	jne    80101c1f <idewait+0x22>
    return -1;
  return 0;
80101c17:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101c1c:	89 c8                	mov    %ecx,%eax
80101c1e:	c3                   	ret    
    return -1;
80101c1f:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101c24:	eb f6                	jmp    80101c1c <idewait+0x1f>

80101c26 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101c26:	55                   	push   %ebp
80101c27:	89 e5                	mov    %esp,%ebp
80101c29:	56                   	push   %esi
80101c2a:	53                   	push   %ebx
  if(b == 0)
80101c2b:	85 c0                	test   %eax,%eax
80101c2d:	0f 84 8f 00 00 00    	je     80101cc2 <idestart+0x9c>
80101c33:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101c35:	8b 58 08             	mov    0x8(%eax),%ebx
80101c38:	81 fb b7 0b 00 00    	cmp    $0xbb7,%ebx
80101c3e:	0f 87 8b 00 00 00    	ja     80101ccf <idestart+0xa9>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101c44:	b8 00 00 00 00       	mov    $0x0,%eax
80101c49:	e8 af ff ff ff       	call   80101bfd <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101c4e:	b8 00 00 00 00       	mov    $0x0,%eax
80101c53:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101c58:	ee                   	out    %al,(%dx)
80101c59:	b8 01 00 00 00       	mov    $0x1,%eax
80101c5e:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101c63:	ee                   	out    %al,(%dx)
80101c64:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101c69:	89 d8                	mov    %ebx,%eax
80101c6b:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101c6c:	0f b6 c7             	movzbl %bh,%eax
80101c6f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101c74:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101c75:	89 d8                	mov    %ebx,%eax
80101c77:	c1 f8 10             	sar    $0x10,%eax
80101c7a:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101c7f:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101c80:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101c84:	c1 e0 04             	shl    $0x4,%eax
80101c87:	83 e0 10             	and    $0x10,%eax
80101c8a:	c1 fb 18             	sar    $0x18,%ebx
80101c8d:	83 e3 0f             	and    $0xf,%ebx
80101c90:	09 d8                	or     %ebx,%eax
80101c92:	83 c8 e0             	or     $0xffffffe0,%eax
80101c95:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101c9a:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101c9b:	f6 06 04             	testb  $0x4,(%esi)
80101c9e:	74 3c                	je     80101cdc <idestart+0xb6>
80101ca0:	b8 30 00 00 00       	mov    $0x30,%eax
80101ca5:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101caa:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101cab:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101cae:	b9 80 00 00 00       	mov    $0x80,%ecx
80101cb3:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101cb8:	fc                   	cld    
80101cb9:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101cbb:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101cbe:	5b                   	pop    %ebx
80101cbf:	5e                   	pop    %esi
80101cc0:	5d                   	pop    %ebp
80101cc1:	c3                   	ret    
    panic("idestart");
80101cc2:	83 ec 0c             	sub    $0xc,%esp
80101cc5:	68 eb 68 10 80       	push   $0x801068eb
80101cca:	e8 79 e6 ff ff       	call   80100348 <panic>
    panic("incorrect blockno");
80101ccf:	83 ec 0c             	sub    $0xc,%esp
80101cd2:	68 f4 68 10 80       	push   $0x801068f4
80101cd7:	e8 6c e6 ff ff       	call   80100348 <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101cdc:	b8 20 00 00 00       	mov    $0x20,%eax
80101ce1:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ce6:	ee                   	out    %al,(%dx)
}
80101ce7:	eb d2                	jmp    80101cbb <idestart+0x95>

80101ce9 <ideinit>:
{
80101ce9:	55                   	push   %ebp
80101cea:	89 e5                	mov    %esp,%ebp
80101cec:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101cef:	68 06 69 10 80       	push   $0x80106906
80101cf4:	68 00 16 11 80       	push   $0x80111600
80101cf9:	e8 87 1e 00 00       	call   80103b85 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101cfe:	83 c4 08             	add    $0x8,%esp
80101d01:	a1 84 17 11 80       	mov    0x80111784,%eax
80101d06:	83 e8 01             	sub    $0x1,%eax
80101d09:	50                   	push   %eax
80101d0a:	6a 0e                	push   $0xe
80101d0c:	e8 50 02 00 00       	call   80101f61 <ioapicenable>
  idewait(0);
80101d11:	b8 00 00 00 00       	mov    $0x0,%eax
80101d16:	e8 e2 fe ff ff       	call   80101bfd <idewait>
80101d1b:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101d20:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d25:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101d26:	83 c4 10             	add    $0x10,%esp
80101d29:	b9 00 00 00 00       	mov    $0x0,%ecx
80101d2e:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101d34:	7f 19                	jg     80101d4f <ideinit+0x66>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d36:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d3b:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101d3c:	84 c0                	test   %al,%al
80101d3e:	75 05                	jne    80101d45 <ideinit+0x5c>
  for(i=0; i<1000; i++){
80101d40:	83 c1 01             	add    $0x1,%ecx
80101d43:	eb e9                	jmp    80101d2e <ideinit+0x45>
      havedisk1 = 1;
80101d45:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80101d4c:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d4f:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101d54:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d59:	ee                   	out    %al,(%dx)
}
80101d5a:	c9                   	leave  
80101d5b:	c3                   	ret    

80101d5c <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101d5c:	55                   	push   %ebp
80101d5d:	89 e5                	mov    %esp,%ebp
80101d5f:	57                   	push   %edi
80101d60:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101d61:	83 ec 0c             	sub    $0xc,%esp
80101d64:	68 00 16 11 80       	push   $0x80111600
80101d69:	e8 53 1f 00 00       	call   80103cc1 <acquire>

  if((b = idequeue) == 0){
80101d6e:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80101d74:	83 c4 10             	add    $0x10,%esp
80101d77:	85 db                	test   %ebx,%ebx
80101d79:	74 4a                	je     80101dc5 <ideintr+0x69>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101d7b:	8b 43 58             	mov    0x58(%ebx),%eax
80101d7e:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101d83:	f6 03 04             	testb  $0x4,(%ebx)
80101d86:	74 4f                	je     80101dd7 <ideintr+0x7b>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101d88:	8b 03                	mov    (%ebx),%eax
80101d8a:	83 c8 02             	or     $0x2,%eax
80101d8d:	89 03                	mov    %eax,(%ebx)
  b->flags &= ~B_DIRTY;
80101d8f:	83 e0 fb             	and    $0xfffffffb,%eax
80101d92:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101d94:	83 ec 0c             	sub    $0xc,%esp
80101d97:	53                   	push   %ebx
80101d98:	e8 d9 1a 00 00       	call   80103876 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101d9d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80101da2:	83 c4 10             	add    $0x10,%esp
80101da5:	85 c0                	test   %eax,%eax
80101da7:	74 05                	je     80101dae <ideintr+0x52>
    idestart(idequeue);
80101da9:	e8 78 fe ff ff       	call   80101c26 <idestart>

  release(&idelock);
80101dae:	83 ec 0c             	sub    $0xc,%esp
80101db1:	68 00 16 11 80       	push   $0x80111600
80101db6:	e8 6b 1f 00 00       	call   80103d26 <release>
80101dbb:	83 c4 10             	add    $0x10,%esp
}
80101dbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101dc1:	5b                   	pop    %ebx
80101dc2:	5f                   	pop    %edi
80101dc3:	5d                   	pop    %ebp
80101dc4:	c3                   	ret    
    release(&idelock);
80101dc5:	83 ec 0c             	sub    $0xc,%esp
80101dc8:	68 00 16 11 80       	push   $0x80111600
80101dcd:	e8 54 1f 00 00       	call   80103d26 <release>
    return;
80101dd2:	83 c4 10             	add    $0x10,%esp
80101dd5:	eb e7                	jmp    80101dbe <ideintr+0x62>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101dd7:	b8 01 00 00 00       	mov    $0x1,%eax
80101ddc:	e8 1c fe ff ff       	call   80101bfd <idewait>
80101de1:	85 c0                	test   %eax,%eax
80101de3:	78 a3                	js     80101d88 <ideintr+0x2c>
    insl(0x1f0, b->data, BSIZE/4);
80101de5:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101de8:	b9 80 00 00 00       	mov    $0x80,%ecx
80101ded:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101df2:	fc                   	cld    
80101df3:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101df5:	eb 91                	jmp    80101d88 <ideintr+0x2c>

80101df7 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101df7:	55                   	push   %ebp
80101df8:	89 e5                	mov    %esp,%ebp
80101dfa:	53                   	push   %ebx
80101dfb:	83 ec 10             	sub    $0x10,%esp
80101dfe:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e01:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e04:	50                   	push   %eax
80101e05:	e8 2d 1d 00 00       	call   80103b37 <holdingsleep>
80101e0a:	83 c4 10             	add    $0x10,%esp
80101e0d:	85 c0                	test   %eax,%eax
80101e0f:	74 37                	je     80101e48 <iderw+0x51>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101e11:	8b 03                	mov    (%ebx),%eax
80101e13:	83 e0 06             	and    $0x6,%eax
80101e16:	83 f8 02             	cmp    $0x2,%eax
80101e19:	74 3a                	je     80101e55 <iderw+0x5e>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101e1b:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101e1f:	74 09                	je     80101e2a <iderw+0x33>
80101e21:	83 3d e0 15 11 80 00 	cmpl   $0x0,0x801115e0
80101e28:	74 38                	je     80101e62 <iderw+0x6b>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101e2a:	83 ec 0c             	sub    $0xc,%esp
80101e2d:	68 00 16 11 80       	push   $0x80111600
80101e32:	e8 8a 1e 00 00       	call   80103cc1 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101e37:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101e3e:	83 c4 10             	add    $0x10,%esp
80101e41:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80101e46:	eb 2a                	jmp    80101e72 <iderw+0x7b>
    panic("iderw: buf not locked");
80101e48:	83 ec 0c             	sub    $0xc,%esp
80101e4b:	68 0a 69 10 80       	push   $0x8010690a
80101e50:	e8 f3 e4 ff ff       	call   80100348 <panic>
    panic("iderw: nothing to do");
80101e55:	83 ec 0c             	sub    $0xc,%esp
80101e58:	68 20 69 10 80       	push   $0x80106920
80101e5d:	e8 e6 e4 ff ff       	call   80100348 <panic>
    panic("iderw: ide disk 1 not present");
80101e62:	83 ec 0c             	sub    $0xc,%esp
80101e65:	68 35 69 10 80       	push   $0x80106935
80101e6a:	e8 d9 e4 ff ff       	call   80100348 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101e6f:	8d 50 58             	lea    0x58(%eax),%edx
80101e72:	8b 02                	mov    (%edx),%eax
80101e74:	85 c0                	test   %eax,%eax
80101e76:	75 f7                	jne    80101e6f <iderw+0x78>
    ;
  *pp = b;
80101e78:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101e7a:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80101e80:	75 1a                	jne    80101e9c <iderw+0xa5>
    idestart(b);
80101e82:	89 d8                	mov    %ebx,%eax
80101e84:	e8 9d fd ff ff       	call   80101c26 <idestart>
80101e89:	eb 11                	jmp    80101e9c <iderw+0xa5>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101e8b:	83 ec 08             	sub    $0x8,%esp
80101e8e:	68 00 16 11 80       	push   $0x80111600
80101e93:	53                   	push   %ebx
80101e94:	e8 75 18 00 00       	call   8010370e <sleep>
80101e99:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101e9c:	8b 03                	mov    (%ebx),%eax
80101e9e:	83 e0 06             	and    $0x6,%eax
80101ea1:	83 f8 02             	cmp    $0x2,%eax
80101ea4:	75 e5                	jne    80101e8b <iderw+0x94>
  }


  release(&idelock);
80101ea6:	83 ec 0c             	sub    $0xc,%esp
80101ea9:	68 00 16 11 80       	push   $0x80111600
80101eae:	e8 73 1e 00 00       	call   80103d26 <release>
}
80101eb3:	83 c4 10             	add    $0x10,%esp
80101eb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101eb9:	c9                   	leave  
80101eba:	c3                   	ret    

80101ebb <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101ebb:	8b 15 34 16 11 80    	mov    0x80111634,%edx
80101ec1:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101ec3:	a1 34 16 11 80       	mov    0x80111634,%eax
80101ec8:	8b 40 10             	mov    0x10(%eax),%eax
}
80101ecb:	c3                   	ret    

80101ecc <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101ecc:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80101ed2:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101ed4:	a1 34 16 11 80       	mov    0x80111634,%eax
80101ed9:	89 50 10             	mov    %edx,0x10(%eax)
}
80101edc:	c3                   	ret    

80101edd <ioapicinit>:

void
ioapicinit(void)
{
80101edd:	55                   	push   %ebp
80101ede:	89 e5                	mov    %esp,%ebp
80101ee0:	57                   	push   %edi
80101ee1:	56                   	push   %esi
80101ee2:	53                   	push   %ebx
80101ee3:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101ee6:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80101eed:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101ef0:	b8 01 00 00 00       	mov    $0x1,%eax
80101ef5:	e8 c1 ff ff ff       	call   80101ebb <ioapicread>
80101efa:	c1 e8 10             	shr    $0x10,%eax
80101efd:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101f00:	b8 00 00 00 00       	mov    $0x0,%eax
80101f05:	e8 b1 ff ff ff       	call   80101ebb <ioapicread>
80101f0a:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101f0d:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
80101f14:	39 c2                	cmp    %eax,%edx
80101f16:	75 07                	jne    80101f1f <ioapicinit+0x42>
{
80101f18:	bb 00 00 00 00       	mov    $0x0,%ebx
80101f1d:	eb 36                	jmp    80101f55 <ioapicinit+0x78>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101f1f:	83 ec 0c             	sub    $0xc,%esp
80101f22:	68 54 69 10 80       	push   $0x80106954
80101f27:	e8 db e6 ff ff       	call   80100607 <cprintf>
80101f2c:	83 c4 10             	add    $0x10,%esp
80101f2f:	eb e7                	jmp    80101f18 <ioapicinit+0x3b>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101f31:	8d 53 20             	lea    0x20(%ebx),%edx
80101f34:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101f3a:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101f3e:	89 f0                	mov    %esi,%eax
80101f40:	e8 87 ff ff ff       	call   80101ecc <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101f45:	8d 46 01             	lea    0x1(%esi),%eax
80101f48:	ba 00 00 00 00       	mov    $0x0,%edx
80101f4d:	e8 7a ff ff ff       	call   80101ecc <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101f52:	83 c3 01             	add    $0x1,%ebx
80101f55:	39 fb                	cmp    %edi,%ebx
80101f57:	7e d8                	jle    80101f31 <ioapicinit+0x54>
  }
}
80101f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5c:	5b                   	pop    %ebx
80101f5d:	5e                   	pop    %esi
80101f5e:	5f                   	pop    %edi
80101f5f:	5d                   	pop    %ebp
80101f60:	c3                   	ret    

80101f61 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101f61:	55                   	push   %ebp
80101f62:	89 e5                	mov    %esp,%ebp
80101f64:	53                   	push   %ebx
80101f65:	83 ec 04             	sub    $0x4,%esp
80101f68:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80101f6b:	8d 50 20             	lea    0x20(%eax),%edx
80101f6e:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80101f72:	89 d8                	mov    %ebx,%eax
80101f74:	e8 53 ff ff ff       	call   80101ecc <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80101f79:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f7c:	c1 e2 18             	shl    $0x18,%edx
80101f7f:	8d 43 01             	lea    0x1(%ebx),%eax
80101f82:	e8 45 ff ff ff       	call   80101ecc <ioapicwrite>
}
80101f87:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f8a:	c9                   	leave  
80101f8b:	c3                   	ret    

80101f8c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80101f8c:	55                   	push   %ebp
80101f8d:	89 e5                	mov    %esp,%ebp
80101f8f:	53                   	push   %ebx
80101f90:	83 ec 04             	sub    $0x4,%esp
80101f93:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80101f96:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80101f9c:	75 4c                	jne    80101fea <kfree+0x5e>
80101f9e:	81 fb d0 56 11 80    	cmp    $0x801156d0,%ebx
80101fa4:	72 44                	jb     80101fea <kfree+0x5e>
80101fa6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80101fac:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80101fb1:	77 37                	ja     80101fea <kfree+0x5e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80101fb3:	83 ec 04             	sub    $0x4,%esp
80101fb6:	68 00 10 00 00       	push   $0x1000
80101fbb:	6a 01                	push   $0x1
80101fbd:	53                   	push   %ebx
80101fbe:	e8 aa 1d 00 00       	call   80103d6d <memset>

  if(kmem.use_lock)
80101fc3:	83 c4 10             	add    $0x10,%esp
80101fc6:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80101fcd:	75 28                	jne    80101ff7 <kfree+0x6b>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80101fcf:	a1 78 16 11 80       	mov    0x80111678,%eax
80101fd4:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80101fd6:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80101fdc:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80101fe3:	75 24                	jne    80102009 <kfree+0x7d>
    release(&kmem.lock);
}
80101fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101fe8:	c9                   	leave  
80101fe9:	c3                   	ret    
    panic("kfree");
80101fea:	83 ec 0c             	sub    $0xc,%esp
80101fed:	68 86 69 10 80       	push   $0x80106986
80101ff2:	e8 51 e3 ff ff       	call   80100348 <panic>
    acquire(&kmem.lock);
80101ff7:	83 ec 0c             	sub    $0xc,%esp
80101ffa:	68 40 16 11 80       	push   $0x80111640
80101fff:	e8 bd 1c 00 00       	call   80103cc1 <acquire>
80102004:	83 c4 10             	add    $0x10,%esp
80102007:	eb c6                	jmp    80101fcf <kfree+0x43>
    release(&kmem.lock);
80102009:	83 ec 0c             	sub    $0xc,%esp
8010200c:	68 40 16 11 80       	push   $0x80111640
80102011:	e8 10 1d 00 00       	call   80103d26 <release>
80102016:	83 c4 10             	add    $0x10,%esp
}
80102019:	eb ca                	jmp    80101fe5 <kfree+0x59>

8010201b <freerange>:
{
8010201b:	55                   	push   %ebp
8010201c:	89 e5                	mov    %esp,%ebp
8010201e:	56                   	push   %esi
8010201f:	53                   	push   %ebx
80102020:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102023:	8b 45 08             	mov    0x8(%ebp),%eax
80102026:	05 ff 0f 00 00       	add    $0xfff,%eax
8010202b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102030:	eb 0e                	jmp    80102040 <freerange+0x25>
    kfree(p);
80102032:	83 ec 0c             	sub    $0xc,%esp
80102035:	50                   	push   %eax
80102036:	e8 51 ff ff ff       	call   80101f8c <kfree>
8010203b:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010203e:	89 f0                	mov    %esi,%eax
80102040:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
80102046:	39 de                	cmp    %ebx,%esi
80102048:	76 e8                	jbe    80102032 <freerange+0x17>
}
8010204a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010204d:	5b                   	pop    %ebx
8010204e:	5e                   	pop    %esi
8010204f:	5d                   	pop    %ebp
80102050:	c3                   	ret    

80102051 <kinit1>:
{
80102051:	55                   	push   %ebp
80102052:	89 e5                	mov    %esp,%ebp
80102054:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
80102057:	68 8c 69 10 80       	push   $0x8010698c
8010205c:	68 40 16 11 80       	push   $0x80111640
80102061:	e8 1f 1b 00 00       	call   80103b85 <initlock>
  kmem.use_lock = 0;
80102066:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
8010206d:	00 00 00 
  freerange(vstart, vend);
80102070:	83 c4 08             	add    $0x8,%esp
80102073:	ff 75 0c             	push   0xc(%ebp)
80102076:	ff 75 08             	push   0x8(%ebp)
80102079:	e8 9d ff ff ff       	call   8010201b <freerange>
}
8010207e:	83 c4 10             	add    $0x10,%esp
80102081:	c9                   	leave  
80102082:	c3                   	ret    

80102083 <kinit2>:
{
80102083:	55                   	push   %ebp
80102084:	89 e5                	mov    %esp,%ebp
80102086:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
80102089:	ff 75 0c             	push   0xc(%ebp)
8010208c:	ff 75 08             	push   0x8(%ebp)
8010208f:	e8 87 ff ff ff       	call   8010201b <freerange>
  kmem.use_lock = 1;
80102094:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010209b:	00 00 00 
}
8010209e:	83 c4 10             	add    $0x10,%esp
801020a1:	c9                   	leave  
801020a2:	c3                   	ret    

801020a3 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801020a3:	55                   	push   %ebp
801020a4:	89 e5                	mov    %esp,%ebp
801020a6:	53                   	push   %ebx
801020a7:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801020aa:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
801020b1:	75 21                	jne    801020d4 <kalloc+0x31>
    acquire(&kmem.lock);
  r = kmem.freelist;
801020b3:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
801020b9:	85 db                	test   %ebx,%ebx
801020bb:	74 07                	je     801020c4 <kalloc+0x21>
    kmem.freelist = r->next;
801020bd:	8b 03                	mov    (%ebx),%eax
801020bf:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
801020c4:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
801020cb:	75 19                	jne    801020e6 <kalloc+0x43>
    release(&kmem.lock);
  return (char*)r;
}
801020cd:	89 d8                	mov    %ebx,%eax
801020cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801020d2:	c9                   	leave  
801020d3:	c3                   	ret    
    acquire(&kmem.lock);
801020d4:	83 ec 0c             	sub    $0xc,%esp
801020d7:	68 40 16 11 80       	push   $0x80111640
801020dc:	e8 e0 1b 00 00       	call   80103cc1 <acquire>
801020e1:	83 c4 10             	add    $0x10,%esp
801020e4:	eb cd                	jmp    801020b3 <kalloc+0x10>
    release(&kmem.lock);
801020e6:	83 ec 0c             	sub    $0xc,%esp
801020e9:	68 40 16 11 80       	push   $0x80111640
801020ee:	e8 33 1c 00 00       	call   80103d26 <release>
801020f3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801020f6:	eb d5                	jmp    801020cd <kalloc+0x2a>

801020f8 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f8:	ba 64 00 00 00       	mov    $0x64,%edx
801020fd:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801020fe:	a8 01                	test   $0x1,%al
80102100:	0f 84 b4 00 00 00    	je     801021ba <kbdgetc+0xc2>
80102106:	ba 60 00 00 00       	mov    $0x60,%edx
8010210b:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
8010210c:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
8010210f:	3c e0                	cmp    $0xe0,%al
80102111:	74 61                	je     80102174 <kbdgetc+0x7c>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102113:	84 c0                	test   %al,%al
80102115:	78 6a                	js     80102181 <kbdgetc+0x89>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102117:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
8010211d:	f6 c2 40             	test   $0x40,%dl
80102120:	74 0f                	je     80102131 <kbdgetc+0x39>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102122:	83 c8 80             	or     $0xffffff80,%eax
80102125:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
80102128:	83 e2 bf             	and    $0xffffffbf,%edx
8010212b:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  }

  shift |= shiftcode[data];
80102131:	0f b6 91 c0 6a 10 80 	movzbl -0x7fef9540(%ecx),%edx
80102138:	0b 15 7c 16 11 80    	or     0x8011167c,%edx
8010213e:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  shift ^= togglecode[data];
80102144:	0f b6 81 c0 69 10 80 	movzbl -0x7fef9640(%ecx),%eax
8010214b:	31 c2                	xor    %eax,%edx
8010214d:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102153:	89 d0                	mov    %edx,%eax
80102155:	83 e0 03             	and    $0x3,%eax
80102158:	8b 04 85 a0 69 10 80 	mov    -0x7fef9660(,%eax,4),%eax
8010215f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102163:	f6 c2 08             	test   $0x8,%dl
80102166:	74 57                	je     801021bf <kbdgetc+0xc7>
    if('a' <= c && c <= 'z')
80102168:	8d 50 9f             	lea    -0x61(%eax),%edx
8010216b:	83 fa 19             	cmp    $0x19,%edx
8010216e:	77 3e                	ja     801021ae <kbdgetc+0xb6>
      c += 'A' - 'a';
80102170:	83 e8 20             	sub    $0x20,%eax
80102173:	c3                   	ret    
    shift |= E0ESC;
80102174:	83 0d 7c 16 11 80 40 	orl    $0x40,0x8011167c
    return 0;
8010217b:	b8 00 00 00 00       	mov    $0x0,%eax
80102180:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102181:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
80102187:	f6 c2 40             	test   $0x40,%dl
8010218a:	75 05                	jne    80102191 <kbdgetc+0x99>
8010218c:	89 c1                	mov    %eax,%ecx
8010218e:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102191:	0f b6 81 c0 6a 10 80 	movzbl -0x7fef9540(%ecx),%eax
80102198:	83 c8 40             	or     $0x40,%eax
8010219b:	0f b6 c0             	movzbl %al,%eax
8010219e:	f7 d0                	not    %eax
801021a0:	21 c2                	and    %eax,%edx
801021a2:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
    return 0;
801021a8:	b8 00 00 00 00       	mov    $0x0,%eax
801021ad:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
801021ae:	8d 50 bf             	lea    -0x41(%eax),%edx
801021b1:	83 fa 19             	cmp    $0x19,%edx
801021b4:	77 09                	ja     801021bf <kbdgetc+0xc7>
      c += 'a' - 'A';
801021b6:	83 c0 20             	add    $0x20,%eax
  }
  return c;
801021b9:	c3                   	ret    
    return -1;
801021ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801021bf:	c3                   	ret    

801021c0 <kbdintr>:

void
kbdintr(void)
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801021c6:	68 f8 20 10 80       	push   $0x801020f8
801021cb:	e8 63 e5 ff ff       	call   80100733 <consoleintr>
}
801021d0:	83 c4 10             	add    $0x10,%esp
801021d3:	c9                   	leave  
801021d4:	c3                   	ret    

801021d5 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801021d5:	8b 0d 80 16 11 80    	mov    0x80111680,%ecx
801021db:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801021de:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
801021e0:	a1 80 16 11 80       	mov    0x80111680,%eax
801021e5:	8b 40 20             	mov    0x20(%eax),%eax
}
801021e8:	c3                   	ret    

801021e9 <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021e9:	ba 70 00 00 00       	mov    $0x70,%edx
801021ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ef:	ba 71 00 00 00       	mov    $0x71,%edx
801021f4:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801021f5:	0f b6 c0             	movzbl %al,%eax
}
801021f8:	c3                   	ret    

801021f9 <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801021f9:	55                   	push   %ebp
801021fa:	89 e5                	mov    %esp,%ebp
801021fc:	53                   	push   %ebx
801021fd:	83 ec 04             	sub    $0x4,%esp
80102200:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
80102202:	b8 00 00 00 00       	mov    $0x0,%eax
80102207:	e8 dd ff ff ff       	call   801021e9 <cmos_read>
8010220c:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
8010220e:	b8 02 00 00 00       	mov    $0x2,%eax
80102213:	e8 d1 ff ff ff       	call   801021e9 <cmos_read>
80102218:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
8010221b:	b8 04 00 00 00       	mov    $0x4,%eax
80102220:	e8 c4 ff ff ff       	call   801021e9 <cmos_read>
80102225:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
80102228:	b8 07 00 00 00       	mov    $0x7,%eax
8010222d:	e8 b7 ff ff ff       	call   801021e9 <cmos_read>
80102232:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
80102235:	b8 08 00 00 00       	mov    $0x8,%eax
8010223a:	e8 aa ff ff ff       	call   801021e9 <cmos_read>
8010223f:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
80102242:	b8 09 00 00 00       	mov    $0x9,%eax
80102247:	e8 9d ff ff ff       	call   801021e9 <cmos_read>
8010224c:	89 43 14             	mov    %eax,0x14(%ebx)
}
8010224f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102252:	c9                   	leave  
80102253:	c3                   	ret    

80102254 <lapicinit>:
  if(!lapic)
80102254:	83 3d 80 16 11 80 00 	cmpl   $0x0,0x80111680
8010225b:	0f 84 fe 00 00 00    	je     8010235f <lapicinit+0x10b>
{
80102261:	55                   	push   %ebp
80102262:	89 e5                	mov    %esp,%ebp
80102264:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102267:	ba 3f 01 00 00       	mov    $0x13f,%edx
8010226c:	b8 3c 00 00 00       	mov    $0x3c,%eax
80102271:	e8 5f ff ff ff       	call   801021d5 <lapicw>
  lapicw(TDCR, X1);
80102276:	ba 0b 00 00 00       	mov    $0xb,%edx
8010227b:	b8 f8 00 00 00       	mov    $0xf8,%eax
80102280:	e8 50 ff ff ff       	call   801021d5 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102285:	ba 20 00 02 00       	mov    $0x20020,%edx
8010228a:	b8 c8 00 00 00       	mov    $0xc8,%eax
8010228f:	e8 41 ff ff ff       	call   801021d5 <lapicw>
  lapicw(TICR, 10000000);
80102294:	ba 80 96 98 00       	mov    $0x989680,%edx
80102299:	b8 e0 00 00 00       	mov    $0xe0,%eax
8010229e:	e8 32 ff ff ff       	call   801021d5 <lapicw>
  lapicw(LINT0, MASKED);
801022a3:	ba 00 00 01 00       	mov    $0x10000,%edx
801022a8:	b8 d4 00 00 00       	mov    $0xd4,%eax
801022ad:	e8 23 ff ff ff       	call   801021d5 <lapicw>
  lapicw(LINT1, MASKED);
801022b2:	ba 00 00 01 00       	mov    $0x10000,%edx
801022b7:	b8 d8 00 00 00       	mov    $0xd8,%eax
801022bc:	e8 14 ff ff ff       	call   801021d5 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801022c1:	a1 80 16 11 80       	mov    0x80111680,%eax
801022c6:	8b 40 30             	mov    0x30(%eax),%eax
801022c9:	c1 e8 10             	shr    $0x10,%eax
801022cc:	a8 fc                	test   $0xfc,%al
801022ce:	75 7b                	jne    8010234b <lapicinit+0xf7>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801022d0:	ba 33 00 00 00       	mov    $0x33,%edx
801022d5:	b8 dc 00 00 00       	mov    $0xdc,%eax
801022da:	e8 f6 fe ff ff       	call   801021d5 <lapicw>
  lapicw(ESR, 0);
801022df:	ba 00 00 00 00       	mov    $0x0,%edx
801022e4:	b8 a0 00 00 00       	mov    $0xa0,%eax
801022e9:	e8 e7 fe ff ff       	call   801021d5 <lapicw>
  lapicw(ESR, 0);
801022ee:	ba 00 00 00 00       	mov    $0x0,%edx
801022f3:	b8 a0 00 00 00       	mov    $0xa0,%eax
801022f8:	e8 d8 fe ff ff       	call   801021d5 <lapicw>
  lapicw(EOI, 0);
801022fd:	ba 00 00 00 00       	mov    $0x0,%edx
80102302:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102307:	e8 c9 fe ff ff       	call   801021d5 <lapicw>
  lapicw(ICRHI, 0);
8010230c:	ba 00 00 00 00       	mov    $0x0,%edx
80102311:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102316:	e8 ba fe ff ff       	call   801021d5 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010231b:	ba 00 85 08 00       	mov    $0x88500,%edx
80102320:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102325:	e8 ab fe ff ff       	call   801021d5 <lapicw>
  while(lapic[ICRLO] & DELIVS)
8010232a:	a1 80 16 11 80       	mov    0x80111680,%eax
8010232f:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
80102335:	f6 c4 10             	test   $0x10,%ah
80102338:	75 f0                	jne    8010232a <lapicinit+0xd6>
  lapicw(TPR, 0);
8010233a:	ba 00 00 00 00       	mov    $0x0,%edx
8010233f:	b8 20 00 00 00       	mov    $0x20,%eax
80102344:	e8 8c fe ff ff       	call   801021d5 <lapicw>
}
80102349:	c9                   	leave  
8010234a:	c3                   	ret    
    lapicw(PCINT, MASKED);
8010234b:	ba 00 00 01 00       	mov    $0x10000,%edx
80102350:	b8 d0 00 00 00       	mov    $0xd0,%eax
80102355:	e8 7b fe ff ff       	call   801021d5 <lapicw>
8010235a:	e9 71 ff ff ff       	jmp    801022d0 <lapicinit+0x7c>
8010235f:	c3                   	ret    

80102360 <lapicid>:
  if (!lapic)
80102360:	a1 80 16 11 80       	mov    0x80111680,%eax
80102365:	85 c0                	test   %eax,%eax
80102367:	74 07                	je     80102370 <lapicid+0x10>
  return lapic[ID] >> 24;
80102369:	8b 40 20             	mov    0x20(%eax),%eax
8010236c:	c1 e8 18             	shr    $0x18,%eax
8010236f:	c3                   	ret    
    return 0;
80102370:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102375:	c3                   	ret    

80102376 <lapiceoi>:
  if(lapic)
80102376:	83 3d 80 16 11 80 00 	cmpl   $0x0,0x80111680
8010237d:	74 17                	je     80102396 <lapiceoi+0x20>
{
8010237f:	55                   	push   %ebp
80102380:	89 e5                	mov    %esp,%ebp
80102382:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
80102385:	ba 00 00 00 00       	mov    $0x0,%edx
8010238a:	b8 2c 00 00 00       	mov    $0x2c,%eax
8010238f:	e8 41 fe ff ff       	call   801021d5 <lapicw>
}
80102394:	c9                   	leave  
80102395:	c3                   	ret    
80102396:	c3                   	ret    

80102397 <microdelay>:
}
80102397:	c3                   	ret    

80102398 <lapicstartap>:
{
80102398:	55                   	push   %ebp
80102399:	89 e5                	mov    %esp,%ebp
8010239b:	57                   	push   %edi
8010239c:	56                   	push   %esi
8010239d:	53                   	push   %ebx
8010239e:	83 ec 0c             	sub    $0xc,%esp
801023a1:	8b 75 08             	mov    0x8(%ebp),%esi
801023a4:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023a7:	b8 0f 00 00 00       	mov    $0xf,%eax
801023ac:	ba 70 00 00 00       	mov    $0x70,%edx
801023b1:	ee                   	out    %al,(%dx)
801023b2:	b8 0a 00 00 00       	mov    $0xa,%eax
801023b7:	ba 71 00 00 00       	mov    $0x71,%edx
801023bc:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801023bd:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801023c4:	00 00 
  wrv[1] = addr >> 4;
801023c6:	89 f8                	mov    %edi,%eax
801023c8:	c1 e8 04             	shr    $0x4,%eax
801023cb:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
801023d1:	c1 e6 18             	shl    $0x18,%esi
801023d4:	89 f2                	mov    %esi,%edx
801023d6:	b8 c4 00 00 00       	mov    $0xc4,%eax
801023db:	e8 f5 fd ff ff       	call   801021d5 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801023e0:	ba 00 c5 00 00       	mov    $0xc500,%edx
801023e5:	b8 c0 00 00 00       	mov    $0xc0,%eax
801023ea:	e8 e6 fd ff ff       	call   801021d5 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
801023ef:	ba 00 85 00 00       	mov    $0x8500,%edx
801023f4:	b8 c0 00 00 00       	mov    $0xc0,%eax
801023f9:	e8 d7 fd ff ff       	call   801021d5 <lapicw>
  for(i = 0; i < 2; i++){
801023fe:	bb 00 00 00 00       	mov    $0x0,%ebx
80102403:	eb 21                	jmp    80102426 <lapicstartap+0x8e>
    lapicw(ICRHI, apicid<<24);
80102405:	89 f2                	mov    %esi,%edx
80102407:	b8 c4 00 00 00       	mov    $0xc4,%eax
8010240c:	e8 c4 fd ff ff       	call   801021d5 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102411:	89 fa                	mov    %edi,%edx
80102413:	c1 ea 0c             	shr    $0xc,%edx
80102416:	80 ce 06             	or     $0x6,%dh
80102419:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010241e:	e8 b2 fd ff ff       	call   801021d5 <lapicw>
  for(i = 0; i < 2; i++){
80102423:	83 c3 01             	add    $0x1,%ebx
80102426:	83 fb 01             	cmp    $0x1,%ebx
80102429:	7e da                	jle    80102405 <lapicstartap+0x6d>
}
8010242b:	83 c4 0c             	add    $0xc,%esp
8010242e:	5b                   	pop    %ebx
8010242f:	5e                   	pop    %esi
80102430:	5f                   	pop    %edi
80102431:	5d                   	pop    %ebp
80102432:	c3                   	ret    

80102433 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102433:	55                   	push   %ebp
80102434:	89 e5                	mov    %esp,%ebp
80102436:	57                   	push   %edi
80102437:	56                   	push   %esi
80102438:	53                   	push   %ebx
80102439:	83 ec 3c             	sub    $0x3c,%esp
8010243c:	8b 75 08             	mov    0x8(%ebp),%esi
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010243f:	b8 0b 00 00 00       	mov    $0xb,%eax
80102444:	e8 a0 fd ff ff       	call   801021e9 <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
80102449:	83 e0 04             	and    $0x4,%eax
8010244c:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010244e:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102451:	e8 a3 fd ff ff       	call   801021f9 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102456:	b8 0a 00 00 00       	mov    $0xa,%eax
8010245b:	e8 89 fd ff ff       	call   801021e9 <cmos_read>
80102460:	a8 80                	test   $0x80,%al
80102462:	75 ea                	jne    8010244e <cmostime+0x1b>
        continue;
    fill_rtcdate(&t2);
80102464:	8d 5d b8             	lea    -0x48(%ebp),%ebx
80102467:	89 d8                	mov    %ebx,%eax
80102469:	e8 8b fd ff ff       	call   801021f9 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010246e:	83 ec 04             	sub    $0x4,%esp
80102471:	6a 18                	push   $0x18
80102473:	53                   	push   %ebx
80102474:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102477:	50                   	push   %eax
80102478:	e8 33 19 00 00       	call   80103db0 <memcmp>
8010247d:	83 c4 10             	add    $0x10,%esp
80102480:	85 c0                	test   %eax,%eax
80102482:	75 ca                	jne    8010244e <cmostime+0x1b>
      break;
  }

  // convert
  if(bcd) {
80102484:	85 ff                	test   %edi,%edi
80102486:	75 78                	jne    80102500 <cmostime+0xcd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102488:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010248b:	89 c2                	mov    %eax,%edx
8010248d:	c1 ea 04             	shr    $0x4,%edx
80102490:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102493:	83 e0 0f             	and    $0xf,%eax
80102496:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102499:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
8010249c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010249f:	89 c2                	mov    %eax,%edx
801024a1:	c1 ea 04             	shr    $0x4,%edx
801024a4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801024a7:	83 e0 0f             	and    $0xf,%eax
801024aa:	8d 04 50             	lea    (%eax,%edx,2),%eax
801024ad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
801024b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
801024b3:	89 c2                	mov    %eax,%edx
801024b5:	c1 ea 04             	shr    $0x4,%edx
801024b8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801024bb:	83 e0 0f             	and    $0xf,%eax
801024be:	8d 04 50             	lea    (%eax,%edx,2),%eax
801024c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
801024c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801024c7:	89 c2                	mov    %eax,%edx
801024c9:	c1 ea 04             	shr    $0x4,%edx
801024cc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801024cf:	83 e0 0f             	and    $0xf,%eax
801024d2:	8d 04 50             	lea    (%eax,%edx,2),%eax
801024d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801024d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801024db:	89 c2                	mov    %eax,%edx
801024dd:	c1 ea 04             	shr    $0x4,%edx
801024e0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801024e3:	83 e0 0f             	and    $0xf,%eax
801024e6:	8d 04 50             	lea    (%eax,%edx,2),%eax
801024e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801024ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801024ef:	89 c2                	mov    %eax,%edx
801024f1:	c1 ea 04             	shr    $0x4,%edx
801024f4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801024f7:	83 e0 0f             	and    $0xf,%eax
801024fa:	8d 04 50             	lea    (%eax,%edx,2),%eax
801024fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
80102500:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102503:	89 06                	mov    %eax,(%esi)
80102505:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102508:	89 46 04             	mov    %eax,0x4(%esi)
8010250b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010250e:	89 46 08             	mov    %eax,0x8(%esi)
80102511:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102514:	89 46 0c             	mov    %eax,0xc(%esi)
80102517:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010251a:	89 46 10             	mov    %eax,0x10(%esi)
8010251d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102520:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102523:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010252a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010252d:	5b                   	pop    %ebx
8010252e:	5e                   	pop    %esi
8010252f:	5f                   	pop    %edi
80102530:	5d                   	pop    %ebp
80102531:	c3                   	ret    

80102532 <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80102532:	55                   	push   %ebp
80102533:	89 e5                	mov    %esp,%ebp
80102535:	53                   	push   %ebx
80102536:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102539:	ff 35 d4 16 11 80    	push   0x801116d4
8010253f:	ff 35 e4 16 11 80    	push   0x801116e4
80102545:	e8 22 dc ff ff       	call   8010016c <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
8010254a:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010254d:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
80102553:	83 c4 10             	add    $0x10,%esp
80102556:	ba 00 00 00 00       	mov    $0x0,%edx
8010255b:	eb 0e                	jmp    8010256b <read_head+0x39>
    log.lh.block[i] = lh->block[i];
8010255d:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102561:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102568:	83 c2 01             	add    $0x1,%edx
8010256b:	39 d3                	cmp    %edx,%ebx
8010256d:	7f ee                	jg     8010255d <read_head+0x2b>
  }
  brelse(buf);
8010256f:	83 ec 0c             	sub    $0xc,%esp
80102572:	50                   	push   %eax
80102573:	e8 5d dc ff ff       	call   801001d5 <brelse>
}
80102578:	83 c4 10             	add    $0x10,%esp
8010257b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010257e:	c9                   	leave  
8010257f:	c3                   	ret    

80102580 <install_trans>:
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	57                   	push   %edi
80102584:	56                   	push   %esi
80102585:	53                   	push   %ebx
80102586:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102589:	be 00 00 00 00       	mov    $0x0,%esi
8010258e:	eb 66                	jmp    801025f6 <install_trans+0x76>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102590:	89 f0                	mov    %esi,%eax
80102592:	03 05 d4 16 11 80    	add    0x801116d4,%eax
80102598:	83 c0 01             	add    $0x1,%eax
8010259b:	83 ec 08             	sub    $0x8,%esp
8010259e:	50                   	push   %eax
8010259f:	ff 35 e4 16 11 80    	push   0x801116e4
801025a5:	e8 c2 db ff ff       	call   8010016c <bread>
801025aa:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801025ac:	83 c4 08             	add    $0x8,%esp
801025af:	ff 34 b5 ec 16 11 80 	push   -0x7feee914(,%esi,4)
801025b6:	ff 35 e4 16 11 80    	push   0x801116e4
801025bc:	e8 ab db ff ff       	call   8010016c <bread>
801025c1:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801025c3:	8d 57 5c             	lea    0x5c(%edi),%edx
801025c6:	8d 40 5c             	lea    0x5c(%eax),%eax
801025c9:	83 c4 0c             	add    $0xc,%esp
801025cc:	68 00 02 00 00       	push   $0x200
801025d1:	52                   	push   %edx
801025d2:	50                   	push   %eax
801025d3:	e8 0d 18 00 00       	call   80103de5 <memmove>
    bwrite(dbuf);  // write dst to disk
801025d8:	89 1c 24             	mov    %ebx,(%esp)
801025db:	e8 ba db ff ff       	call   8010019a <bwrite>
    brelse(lbuf);
801025e0:	89 3c 24             	mov    %edi,(%esp)
801025e3:	e8 ed db ff ff       	call   801001d5 <brelse>
    brelse(dbuf);
801025e8:	89 1c 24             	mov    %ebx,(%esp)
801025eb:	e8 e5 db ff ff       	call   801001d5 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801025f0:	83 c6 01             	add    $0x1,%esi
801025f3:	83 c4 10             	add    $0x10,%esp
801025f6:	39 35 e8 16 11 80    	cmp    %esi,0x801116e8
801025fc:	7f 92                	jg     80102590 <install_trans+0x10>
}
801025fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102601:	5b                   	pop    %ebx
80102602:	5e                   	pop    %esi
80102603:	5f                   	pop    %edi
80102604:	5d                   	pop    %ebp
80102605:	c3                   	ret    

80102606 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102606:	55                   	push   %ebp
80102607:	89 e5                	mov    %esp,%ebp
80102609:	53                   	push   %ebx
8010260a:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
8010260d:	ff 35 d4 16 11 80    	push   0x801116d4
80102613:	ff 35 e4 16 11 80    	push   0x801116e4
80102619:	e8 4e db ff ff       	call   8010016c <bread>
8010261e:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102620:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
80102626:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102629:	83 c4 10             	add    $0x10,%esp
8010262c:	b8 00 00 00 00       	mov    $0x0,%eax
80102631:	eb 0e                	jmp    80102641 <write_head+0x3b>
    hb->block[i] = log.lh.block[i];
80102633:	8b 14 85 ec 16 11 80 	mov    -0x7feee914(,%eax,4),%edx
8010263a:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
8010263e:	83 c0 01             	add    $0x1,%eax
80102641:	39 c1                	cmp    %eax,%ecx
80102643:	7f ee                	jg     80102633 <write_head+0x2d>
  }
  bwrite(buf);
80102645:	83 ec 0c             	sub    $0xc,%esp
80102648:	53                   	push   %ebx
80102649:	e8 4c db ff ff       	call   8010019a <bwrite>
  brelse(buf);
8010264e:	89 1c 24             	mov    %ebx,(%esp)
80102651:	e8 7f db ff ff       	call   801001d5 <brelse>
}
80102656:	83 c4 10             	add    $0x10,%esp
80102659:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010265c:	c9                   	leave  
8010265d:	c3                   	ret    

8010265e <recover_from_log>:

static void
recover_from_log(void)
{
8010265e:	55                   	push   %ebp
8010265f:	89 e5                	mov    %esp,%ebp
80102661:	83 ec 08             	sub    $0x8,%esp
  read_head();
80102664:	e8 c9 fe ff ff       	call   80102532 <read_head>
  install_trans(); // if committed, copy from log to disk
80102669:	e8 12 ff ff ff       	call   80102580 <install_trans>
  log.lh.n = 0;
8010266e:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102675:	00 00 00 
  write_head(); // clear the log
80102678:	e8 89 ff ff ff       	call   80102606 <write_head>
}
8010267d:	c9                   	leave  
8010267e:	c3                   	ret    

8010267f <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
8010267f:	55                   	push   %ebp
80102680:	89 e5                	mov    %esp,%ebp
80102682:	57                   	push   %edi
80102683:	56                   	push   %esi
80102684:	53                   	push   %ebx
80102685:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102688:	be 00 00 00 00       	mov    $0x0,%esi
8010268d:	eb 66                	jmp    801026f5 <write_log+0x76>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010268f:	89 f0                	mov    %esi,%eax
80102691:	03 05 d4 16 11 80    	add    0x801116d4,%eax
80102697:	83 c0 01             	add    $0x1,%eax
8010269a:	83 ec 08             	sub    $0x8,%esp
8010269d:	50                   	push   %eax
8010269e:	ff 35 e4 16 11 80    	push   0x801116e4
801026a4:	e8 c3 da ff ff       	call   8010016c <bread>
801026a9:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801026ab:	83 c4 08             	add    $0x8,%esp
801026ae:	ff 34 b5 ec 16 11 80 	push   -0x7feee914(,%esi,4)
801026b5:	ff 35 e4 16 11 80    	push   0x801116e4
801026bb:	e8 ac da ff ff       	call   8010016c <bread>
801026c0:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801026c2:	8d 50 5c             	lea    0x5c(%eax),%edx
801026c5:	8d 43 5c             	lea    0x5c(%ebx),%eax
801026c8:	83 c4 0c             	add    $0xc,%esp
801026cb:	68 00 02 00 00       	push   $0x200
801026d0:	52                   	push   %edx
801026d1:	50                   	push   %eax
801026d2:	e8 0e 17 00 00       	call   80103de5 <memmove>
    bwrite(to);  // write the log
801026d7:	89 1c 24             	mov    %ebx,(%esp)
801026da:	e8 bb da ff ff       	call   8010019a <bwrite>
    brelse(from);
801026df:	89 3c 24             	mov    %edi,(%esp)
801026e2:	e8 ee da ff ff       	call   801001d5 <brelse>
    brelse(to);
801026e7:	89 1c 24             	mov    %ebx,(%esp)
801026ea:	e8 e6 da ff ff       	call   801001d5 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801026ef:	83 c6 01             	add    $0x1,%esi
801026f2:	83 c4 10             	add    $0x10,%esp
801026f5:	39 35 e8 16 11 80    	cmp    %esi,0x801116e8
801026fb:	7f 92                	jg     8010268f <write_log+0x10>
  }
}
801026fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102700:	5b                   	pop    %ebx
80102701:	5e                   	pop    %esi
80102702:	5f                   	pop    %edi
80102703:	5d                   	pop    %ebp
80102704:	c3                   	ret    

80102705 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
80102705:	83 3d e8 16 11 80 00 	cmpl   $0x0,0x801116e8
8010270c:	7f 01                	jg     8010270f <commit+0xa>
8010270e:	c3                   	ret    
{
8010270f:	55                   	push   %ebp
80102710:	89 e5                	mov    %esp,%ebp
80102712:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
80102715:	e8 65 ff ff ff       	call   8010267f <write_log>
    write_head();    // Write header to disk -- the real commit
8010271a:	e8 e7 fe ff ff       	call   80102606 <write_head>
    install_trans(); // Now install writes to home locations
8010271f:	e8 5c fe ff ff       	call   80102580 <install_trans>
    log.lh.n = 0;
80102724:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
8010272b:	00 00 00 
    write_head();    // Erase the transaction from the log
8010272e:	e8 d3 fe ff ff       	call   80102606 <write_head>
  }
}
80102733:	c9                   	leave  
80102734:	c3                   	ret    

80102735 <initlog>:
{
80102735:	55                   	push   %ebp
80102736:	89 e5                	mov    %esp,%ebp
80102738:	53                   	push   %ebx
80102739:	83 ec 2c             	sub    $0x2c,%esp
8010273c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010273f:	68 c0 6b 10 80       	push   $0x80106bc0
80102744:	68 a0 16 11 80       	push   $0x801116a0
80102749:	e8 37 14 00 00       	call   80103b85 <initlock>
  readsb(dev, &sb);
8010274e:	83 c4 08             	add    $0x8,%esp
80102751:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102754:	50                   	push   %eax
80102755:	53                   	push   %ebx
80102756:	e8 4b eb ff ff       	call   801012a6 <readsb>
  log.start = sb.logstart;
8010275b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010275e:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102763:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102766:	a3 d8 16 11 80       	mov    %eax,0x801116d8
  log.dev = dev;
8010276b:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  recover_from_log();
80102771:	e8 e8 fe ff ff       	call   8010265e <recover_from_log>
}
80102776:	83 c4 10             	add    $0x10,%esp
80102779:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277c:	c9                   	leave  
8010277d:	c3                   	ret    

8010277e <begin_op>:
{
8010277e:	55                   	push   %ebp
8010277f:	89 e5                	mov    %esp,%ebp
80102781:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102784:	68 a0 16 11 80       	push   $0x801116a0
80102789:	e8 33 15 00 00       	call   80103cc1 <acquire>
8010278e:	83 c4 10             	add    $0x10,%esp
80102791:	eb 15                	jmp    801027a8 <begin_op+0x2a>
      sleep(&log, &log.lock);
80102793:	83 ec 08             	sub    $0x8,%esp
80102796:	68 a0 16 11 80       	push   $0x801116a0
8010279b:	68 a0 16 11 80       	push   $0x801116a0
801027a0:	e8 69 0f 00 00       	call   8010370e <sleep>
801027a5:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801027a8:	83 3d e0 16 11 80 00 	cmpl   $0x0,0x801116e0
801027af:	75 e2                	jne    80102793 <begin_op+0x15>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801027b1:	a1 dc 16 11 80       	mov    0x801116dc,%eax
801027b6:	83 c0 01             	add    $0x1,%eax
801027b9:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801027bc:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
801027bf:	03 15 e8 16 11 80    	add    0x801116e8,%edx
801027c5:	83 fa 1e             	cmp    $0x1e,%edx
801027c8:	7e 17                	jle    801027e1 <begin_op+0x63>
      sleep(&log, &log.lock);
801027ca:	83 ec 08             	sub    $0x8,%esp
801027cd:	68 a0 16 11 80       	push   $0x801116a0
801027d2:	68 a0 16 11 80       	push   $0x801116a0
801027d7:	e8 32 0f 00 00       	call   8010370e <sleep>
801027dc:	83 c4 10             	add    $0x10,%esp
801027df:	eb c7                	jmp    801027a8 <begin_op+0x2a>
      log.outstanding += 1;
801027e1:	a3 dc 16 11 80       	mov    %eax,0x801116dc
      release(&log.lock);
801027e6:	83 ec 0c             	sub    $0xc,%esp
801027e9:	68 a0 16 11 80       	push   $0x801116a0
801027ee:	e8 33 15 00 00       	call   80103d26 <release>
}
801027f3:	83 c4 10             	add    $0x10,%esp
801027f6:	c9                   	leave  
801027f7:	c3                   	ret    

801027f8 <end_op>:
{
801027f8:	55                   	push   %ebp
801027f9:	89 e5                	mov    %esp,%ebp
801027fb:	53                   	push   %ebx
801027fc:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
801027ff:	68 a0 16 11 80       	push   $0x801116a0
80102804:	e8 b8 14 00 00       	call   80103cc1 <acquire>
  log.outstanding -= 1;
80102809:	a1 dc 16 11 80       	mov    0x801116dc,%eax
8010280e:	83 e8 01             	sub    $0x1,%eax
80102811:	a3 dc 16 11 80       	mov    %eax,0x801116dc
  if(log.committing)
80102816:	8b 1d e0 16 11 80    	mov    0x801116e0,%ebx
8010281c:	83 c4 10             	add    $0x10,%esp
8010281f:	85 db                	test   %ebx,%ebx
80102821:	75 2c                	jne    8010284f <end_op+0x57>
  if(log.outstanding == 0){
80102823:	85 c0                	test   %eax,%eax
80102825:	75 35                	jne    8010285c <end_op+0x64>
    log.committing = 1;
80102827:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
8010282e:	00 00 00 
    do_commit = 1;
80102831:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
80102836:	83 ec 0c             	sub    $0xc,%esp
80102839:	68 a0 16 11 80       	push   $0x801116a0
8010283e:	e8 e3 14 00 00       	call   80103d26 <release>
  if(do_commit){
80102843:	83 c4 10             	add    $0x10,%esp
80102846:	85 db                	test   %ebx,%ebx
80102848:	75 24                	jne    8010286e <end_op+0x76>
}
8010284a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010284d:	c9                   	leave  
8010284e:	c3                   	ret    
    panic("log.committing");
8010284f:	83 ec 0c             	sub    $0xc,%esp
80102852:	68 c4 6b 10 80       	push   $0x80106bc4
80102857:	e8 ec da ff ff       	call   80100348 <panic>
    wakeup(&log);
8010285c:	83 ec 0c             	sub    $0xc,%esp
8010285f:	68 a0 16 11 80       	push   $0x801116a0
80102864:	e8 0d 10 00 00       	call   80103876 <wakeup>
80102869:	83 c4 10             	add    $0x10,%esp
8010286c:	eb c8                	jmp    80102836 <end_op+0x3e>
    commit();
8010286e:	e8 92 fe ff ff       	call   80102705 <commit>
    acquire(&log.lock);
80102873:	83 ec 0c             	sub    $0xc,%esp
80102876:	68 a0 16 11 80       	push   $0x801116a0
8010287b:	e8 41 14 00 00       	call   80103cc1 <acquire>
    log.committing = 0;
80102880:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102887:	00 00 00 
    wakeup(&log);
8010288a:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
80102891:	e8 e0 0f 00 00       	call   80103876 <wakeup>
    release(&log.lock);
80102896:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
8010289d:	e8 84 14 00 00       	call   80103d26 <release>
801028a2:	83 c4 10             	add    $0x10,%esp
}
801028a5:	eb a3                	jmp    8010284a <end_op+0x52>

801028a7 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801028a7:	55                   	push   %ebp
801028a8:	89 e5                	mov    %esp,%ebp
801028aa:	53                   	push   %ebx
801028ab:	83 ec 04             	sub    $0x4,%esp
801028ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801028b1:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
801028b7:	83 fa 1d             	cmp    $0x1d,%edx
801028ba:	7f 2c                	jg     801028e8 <log_write+0x41>
801028bc:	a1 d8 16 11 80       	mov    0x801116d8,%eax
801028c1:	83 e8 01             	sub    $0x1,%eax
801028c4:	39 c2                	cmp    %eax,%edx
801028c6:	7d 20                	jge    801028e8 <log_write+0x41>
    panic("too big a transaction");
  if (log.outstanding < 1)
801028c8:	83 3d dc 16 11 80 00 	cmpl   $0x0,0x801116dc
801028cf:	7e 24                	jle    801028f5 <log_write+0x4e>
    panic("log_write outside of trans");

  acquire(&log.lock);
801028d1:	83 ec 0c             	sub    $0xc,%esp
801028d4:	68 a0 16 11 80       	push   $0x801116a0
801028d9:	e8 e3 13 00 00       	call   80103cc1 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801028de:	83 c4 10             	add    $0x10,%esp
801028e1:	b8 00 00 00 00       	mov    $0x0,%eax
801028e6:	eb 1d                	jmp    80102905 <log_write+0x5e>
    panic("too big a transaction");
801028e8:	83 ec 0c             	sub    $0xc,%esp
801028eb:	68 d3 6b 10 80       	push   $0x80106bd3
801028f0:	e8 53 da ff ff       	call   80100348 <panic>
    panic("log_write outside of trans");
801028f5:	83 ec 0c             	sub    $0xc,%esp
801028f8:	68 e9 6b 10 80       	push   $0x80106be9
801028fd:	e8 46 da ff ff       	call   80100348 <panic>
  for (i = 0; i < log.lh.n; i++) {
80102902:	83 c0 01             	add    $0x1,%eax
80102905:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
8010290b:	39 c2                	cmp    %eax,%edx
8010290d:	7e 0c                	jle    8010291b <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010290f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102912:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
80102919:	75 e7                	jne    80102902 <log_write+0x5b>
      break;
  }
  log.lh.block[i] = b->blockno;
8010291b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010291e:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
80102925:	39 c2                	cmp    %eax,%edx
80102927:	74 18                	je     80102941 <log_write+0x9a>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102929:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
8010292c:	83 ec 0c             	sub    $0xc,%esp
8010292f:	68 a0 16 11 80       	push   $0x801116a0
80102934:	e8 ed 13 00 00       	call   80103d26 <release>
}
80102939:	83 c4 10             	add    $0x10,%esp
8010293c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010293f:	c9                   	leave  
80102940:	c3                   	ret    
    log.lh.n++;
80102941:	83 c2 01             	add    $0x1,%edx
80102944:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
8010294a:	eb dd                	jmp    80102929 <log_write+0x82>

8010294c <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010294c:	55                   	push   %ebp
8010294d:	89 e5                	mov    %esp,%ebp
8010294f:	53                   	push   %ebx
80102950:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102953:	68 8a 00 00 00       	push   $0x8a
80102958:	68 8c a4 10 80       	push   $0x8010a48c
8010295d:	68 00 70 00 80       	push   $0x80007000
80102962:	e8 7e 14 00 00       	call   80103de5 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102967:	83 c4 10             	add    $0x10,%esp
8010296a:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
8010296f:	eb 06                	jmp    80102977 <startothers+0x2b>
80102971:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102977:	69 05 84 17 11 80 b0 	imul   $0xb0,0x80111784,%eax
8010297e:	00 00 00 
80102981:	05 a0 17 11 80       	add    $0x801117a0,%eax
80102986:	39 d8                	cmp    %ebx,%eax
80102988:	76 4c                	jbe    801029d6 <startothers+0x8a>
    if(c == mycpu())  // We've started already.
8010298a:	e8 bc 07 00 00       	call   8010314b <mycpu>
8010298f:	39 c3                	cmp    %eax,%ebx
80102991:	74 de                	je     80102971 <startothers+0x25>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102993:	e8 0b f7 ff ff       	call   801020a3 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102998:	05 00 10 00 00       	add    $0x1000,%eax
8010299d:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
801029a2:	c7 05 f8 6f 00 80 1a 	movl   $0x80102a1a,0x80006ff8
801029a9:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801029ac:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801029b3:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
801029b6:	83 ec 08             	sub    $0x8,%esp
801029b9:	68 00 70 00 00       	push   $0x7000
801029be:	0f b6 03             	movzbl (%ebx),%eax
801029c1:	50                   	push   %eax
801029c2:	e8 d1 f9 ff ff       	call   80102398 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801029c7:	83 c4 10             	add    $0x10,%esp
801029ca:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801029d0:	85 c0                	test   %eax,%eax
801029d2:	74 f6                	je     801029ca <startothers+0x7e>
801029d4:	eb 9b                	jmp    80102971 <startothers+0x25>
      ;
  }
}
801029d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029d9:	c9                   	leave  
801029da:	c3                   	ret    

801029db <mpmain>:
{
801029db:	55                   	push   %ebp
801029dc:	89 e5                	mov    %esp,%ebp
801029de:	53                   	push   %ebx
801029df:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801029e2:	e8 c0 07 00 00       	call   801031a7 <cpuid>
801029e7:	89 c3                	mov    %eax,%ebx
801029e9:	e8 b9 07 00 00       	call   801031a7 <cpuid>
801029ee:	83 ec 04             	sub    $0x4,%esp
801029f1:	53                   	push   %ebx
801029f2:	50                   	push   %eax
801029f3:	68 04 6c 10 80       	push   $0x80106c04
801029f8:	e8 0a dc ff ff       	call   80100607 <cprintf>
  idtinit();       // load idt register
801029fd:	e8 47 25 00 00       	call   80104f49 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102a02:	e8 44 07 00 00       	call   8010314b <mycpu>
80102a07:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a09:	b8 01 00 00 00       	mov    $0x1,%eax
80102a0e:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102a15:	e8 2b 0a 00 00       	call   80103445 <scheduler>

80102a1a <mpenter>:
{
80102a1a:	55                   	push   %ebp
80102a1b:	89 e5                	mov    %esp,%ebp
80102a1d:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102a20:	e8 50 36 00 00       	call   80106075 <switchkvm>
  seginit();
80102a25:	e8 d6 33 00 00       	call   80105e00 <seginit>
  lapicinit();
80102a2a:	e8 25 f8 ff ff       	call   80102254 <lapicinit>
  mpmain();
80102a2f:	e8 a7 ff ff ff       	call   801029db <mpmain>

80102a34 <main>:
{
80102a34:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102a38:	83 e4 f0             	and    $0xfffffff0,%esp
80102a3b:	ff 71 fc             	push   -0x4(%ecx)
80102a3e:	55                   	push   %ebp
80102a3f:	89 e5                	mov    %esp,%ebp
80102a41:	51                   	push   %ecx
80102a42:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102a45:	68 00 00 40 80       	push   $0x80400000
80102a4a:	68 d0 56 11 80       	push   $0x801156d0
80102a4f:	e8 fd f5 ff ff       	call   80102051 <kinit1>
  kvmalloc();      // kernel page table
80102a54:	e8 e8 3a 00 00       	call   80106541 <kvmalloc>
  mpinit();        // detect other processors
80102a59:	e8 c1 01 00 00       	call   80102c1f <mpinit>
  lapicinit();     // interrupt controller
80102a5e:	e8 f1 f7 ff ff       	call   80102254 <lapicinit>
  seginit();       // segment descriptors
80102a63:	e8 98 33 00 00       	call   80105e00 <seginit>
  picinit();       // disable pic
80102a68:	e8 88 02 00 00       	call   80102cf5 <picinit>
  ioapicinit();    // another interrupt controller
80102a6d:	e8 6b f4 ff ff       	call   80101edd <ioapicinit>
  consoleinit();   // console hardware
80102a72:	e8 13 de ff ff       	call   8010088a <consoleinit>
  uartinit();      // serial port
80102a77:	e8 74 27 00 00       	call   801051f0 <uartinit>
  pinit();         // process table
80102a7c:	e8 b0 06 00 00       	call   80103131 <pinit>
  tvinit();        // trap vectors
80102a81:	e8 be 23 00 00       	call   80104e44 <tvinit>
  binit();         // buffer cache
80102a86:	e8 69 d6 ff ff       	call   801000f4 <binit>
  fileinit();      // file table
80102a8b:	e8 73 e1 ff ff       	call   80100c03 <fileinit>
  ideinit();       // disk 
80102a90:	e8 54 f2 ff ff       	call   80101ce9 <ideinit>
  startothers();   // start other processors
80102a95:	e8 b2 fe ff ff       	call   8010294c <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102a9a:	83 c4 08             	add    $0x8,%esp
80102a9d:	68 00 00 00 8e       	push   $0x8e000000
80102aa2:	68 00 00 40 80       	push   $0x80400000
80102aa7:	e8 d7 f5 ff ff       	call   80102083 <kinit2>
  userinit();      // first user process
80102aac:	e8 34 07 00 00       	call   801031e5 <userinit>
  mpmain();        // finish this processor's setup
80102ab1:	e8 25 ff ff ff       	call   801029db <mpmain>

80102ab6 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102ab6:	55                   	push   %ebp
80102ab7:	89 e5                	mov    %esp,%ebp
80102ab9:	56                   	push   %esi
80102aba:	53                   	push   %ebx
80102abb:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102abd:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102ac2:	b9 00 00 00 00       	mov    $0x0,%ecx
80102ac7:	eb 09                	jmp    80102ad2 <sum+0x1c>
    sum += addr[i];
80102ac9:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102acd:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102acf:	83 c1 01             	add    $0x1,%ecx
80102ad2:	39 d1                	cmp    %edx,%ecx
80102ad4:	7c f3                	jl     80102ac9 <sum+0x13>
  return sum;
}
80102ad6:	5b                   	pop    %ebx
80102ad7:	5e                   	pop    %esi
80102ad8:	5d                   	pop    %ebp
80102ad9:	c3                   	ret    

80102ada <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102ada:	55                   	push   %ebp
80102adb:	89 e5                	mov    %esp,%ebp
80102add:	56                   	push   %esi
80102ade:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102adf:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102ae5:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102ae7:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102ae9:	eb 03                	jmp    80102aee <mpsearch1+0x14>
80102aeb:	83 c3 10             	add    $0x10,%ebx
80102aee:	39 f3                	cmp    %esi,%ebx
80102af0:	73 29                	jae    80102b1b <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102af2:	83 ec 04             	sub    $0x4,%esp
80102af5:	6a 04                	push   $0x4
80102af7:	68 18 6c 10 80       	push   $0x80106c18
80102afc:	53                   	push   %ebx
80102afd:	e8 ae 12 00 00       	call   80103db0 <memcmp>
80102b02:	83 c4 10             	add    $0x10,%esp
80102b05:	85 c0                	test   %eax,%eax
80102b07:	75 e2                	jne    80102aeb <mpsearch1+0x11>
80102b09:	ba 10 00 00 00       	mov    $0x10,%edx
80102b0e:	89 d8                	mov    %ebx,%eax
80102b10:	e8 a1 ff ff ff       	call   80102ab6 <sum>
80102b15:	84 c0                	test   %al,%al
80102b17:	75 d2                	jne    80102aeb <mpsearch1+0x11>
80102b19:	eb 05                	jmp    80102b20 <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102b1b:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102b20:	89 d8                	mov    %ebx,%eax
80102b22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b25:	5b                   	pop    %ebx
80102b26:	5e                   	pop    %esi
80102b27:	5d                   	pop    %ebp
80102b28:	c3                   	ret    

80102b29 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102b29:	55                   	push   %ebp
80102b2a:	89 e5                	mov    %esp,%ebp
80102b2c:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102b2f:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102b36:	c1 e0 08             	shl    $0x8,%eax
80102b39:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102b40:	09 d0                	or     %edx,%eax
80102b42:	c1 e0 04             	shl    $0x4,%eax
80102b45:	74 1f                	je     80102b66 <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102b47:	ba 00 04 00 00       	mov    $0x400,%edx
80102b4c:	e8 89 ff ff ff       	call   80102ada <mpsearch1>
80102b51:	85 c0                	test   %eax,%eax
80102b53:	75 0f                	jne    80102b64 <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102b55:	ba 00 00 01 00       	mov    $0x10000,%edx
80102b5a:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102b5f:	e8 76 ff ff ff       	call   80102ada <mpsearch1>
}
80102b64:	c9                   	leave  
80102b65:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102b66:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102b6d:	c1 e0 08             	shl    $0x8,%eax
80102b70:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102b77:	09 d0                	or     %edx,%eax
80102b79:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102b7c:	2d 00 04 00 00       	sub    $0x400,%eax
80102b81:	ba 00 04 00 00       	mov    $0x400,%edx
80102b86:	e8 4f ff ff ff       	call   80102ada <mpsearch1>
80102b8b:	85 c0                	test   %eax,%eax
80102b8d:	75 d5                	jne    80102b64 <mpsearch+0x3b>
80102b8f:	eb c4                	jmp    80102b55 <mpsearch+0x2c>

80102b91 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102b91:	55                   	push   %ebp
80102b92:	89 e5                	mov    %esp,%ebp
80102b94:	57                   	push   %edi
80102b95:	56                   	push   %esi
80102b96:	53                   	push   %ebx
80102b97:	83 ec 1c             	sub    $0x1c,%esp
80102b9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102b9d:	e8 87 ff ff ff       	call   80102b29 <mpsearch>
80102ba2:	89 c3                	mov    %eax,%ebx
80102ba4:	85 c0                	test   %eax,%eax
80102ba6:	74 5a                	je     80102c02 <mpconfig+0x71>
80102ba8:	8b 70 04             	mov    0x4(%eax),%esi
80102bab:	85 f6                	test   %esi,%esi
80102bad:	74 57                	je     80102c06 <mpconfig+0x75>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102baf:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102bb5:	83 ec 04             	sub    $0x4,%esp
80102bb8:	6a 04                	push   $0x4
80102bba:	68 1d 6c 10 80       	push   $0x80106c1d
80102bbf:	57                   	push   %edi
80102bc0:	e8 eb 11 00 00       	call   80103db0 <memcmp>
80102bc5:	83 c4 10             	add    $0x10,%esp
80102bc8:	85 c0                	test   %eax,%eax
80102bca:	75 3e                	jne    80102c0a <mpconfig+0x79>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102bcc:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80102bd3:	3c 01                	cmp    $0x1,%al
80102bd5:	0f 95 c2             	setne  %dl
80102bd8:	3c 04                	cmp    $0x4,%al
80102bda:	0f 95 c0             	setne  %al
80102bdd:	84 c2                	test   %al,%dl
80102bdf:	75 30                	jne    80102c11 <mpconfig+0x80>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102be1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102be8:	89 f8                	mov    %edi,%eax
80102bea:	e8 c7 fe ff ff       	call   80102ab6 <sum>
80102bef:	84 c0                	test   %al,%al
80102bf1:	75 25                	jne    80102c18 <mpconfig+0x87>
    return 0;
  *pmp = mp;
80102bf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102bf6:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102bf8:	89 f8                	mov    %edi,%eax
80102bfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bfd:	5b                   	pop    %ebx
80102bfe:	5e                   	pop    %esi
80102bff:	5f                   	pop    %edi
80102c00:	5d                   	pop    %ebp
80102c01:	c3                   	ret    
    return 0;
80102c02:	89 c7                	mov    %eax,%edi
80102c04:	eb f2                	jmp    80102bf8 <mpconfig+0x67>
80102c06:	89 f7                	mov    %esi,%edi
80102c08:	eb ee                	jmp    80102bf8 <mpconfig+0x67>
    return 0;
80102c0a:	bf 00 00 00 00       	mov    $0x0,%edi
80102c0f:	eb e7                	jmp    80102bf8 <mpconfig+0x67>
    return 0;
80102c11:	bf 00 00 00 00       	mov    $0x0,%edi
80102c16:	eb e0                	jmp    80102bf8 <mpconfig+0x67>
    return 0;
80102c18:	bf 00 00 00 00       	mov    $0x0,%edi
80102c1d:	eb d9                	jmp    80102bf8 <mpconfig+0x67>

80102c1f <mpinit>:

void
mpinit(void)
{
80102c1f:	55                   	push   %ebp
80102c20:	89 e5                	mov    %esp,%ebp
80102c22:	57                   	push   %edi
80102c23:	56                   	push   %esi
80102c24:	53                   	push   %ebx
80102c25:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102c28:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102c2b:	e8 61 ff ff ff       	call   80102b91 <mpconfig>
80102c30:	85 c0                	test   %eax,%eax
80102c32:	74 19                	je     80102c4d <mpinit+0x2e>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102c34:	8b 50 24             	mov    0x24(%eax),%edx
80102c37:	89 15 80 16 11 80    	mov    %edx,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102c3d:	8d 50 2c             	lea    0x2c(%eax),%edx
80102c40:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102c44:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102c46:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102c4b:	eb 20                	jmp    80102c6d <mpinit+0x4e>
    panic("Expect to run on an SMP");
80102c4d:	83 ec 0c             	sub    $0xc,%esp
80102c50:	68 22 6c 10 80       	push   $0x80106c22
80102c55:	e8 ee d6 ff ff       	call   80100348 <panic>
    switch(*p){
80102c5a:	bb 00 00 00 00       	mov    $0x0,%ebx
80102c5f:	eb 0c                	jmp    80102c6d <mpinit+0x4e>
80102c61:	83 e8 03             	sub    $0x3,%eax
80102c64:	3c 01                	cmp    $0x1,%al
80102c66:	76 1a                	jbe    80102c82 <mpinit+0x63>
80102c68:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102c6d:	39 ca                	cmp    %ecx,%edx
80102c6f:	73 4d                	jae    80102cbe <mpinit+0x9f>
    switch(*p){
80102c71:	0f b6 02             	movzbl (%edx),%eax
80102c74:	3c 02                	cmp    $0x2,%al
80102c76:	74 38                	je     80102cb0 <mpinit+0x91>
80102c78:	77 e7                	ja     80102c61 <mpinit+0x42>
80102c7a:	84 c0                	test   %al,%al
80102c7c:	74 09                	je     80102c87 <mpinit+0x68>
80102c7e:	3c 01                	cmp    $0x1,%al
80102c80:	75 d8                	jne    80102c5a <mpinit+0x3b>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102c82:	83 c2 08             	add    $0x8,%edx
      continue;
80102c85:	eb e6                	jmp    80102c6d <mpinit+0x4e>
      if(ncpu < NCPU) {
80102c87:	8b 35 84 17 11 80    	mov    0x80111784,%esi
80102c8d:	83 fe 07             	cmp    $0x7,%esi
80102c90:	7f 19                	jg     80102cab <mpinit+0x8c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102c92:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102c96:	69 fe b0 00 00 00    	imul   $0xb0,%esi,%edi
80102c9c:	88 87 a0 17 11 80    	mov    %al,-0x7feee860(%edi)
        ncpu++;
80102ca2:	83 c6 01             	add    $0x1,%esi
80102ca5:	89 35 84 17 11 80    	mov    %esi,0x80111784
      p += sizeof(struct mpproc);
80102cab:	83 c2 14             	add    $0x14,%edx
      continue;
80102cae:	eb bd                	jmp    80102c6d <mpinit+0x4e>
      ioapicid = ioapic->apicno;
80102cb0:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102cb4:	a2 80 17 11 80       	mov    %al,0x80111780
      p += sizeof(struct mpioapic);
80102cb9:	83 c2 08             	add    $0x8,%edx
      continue;
80102cbc:	eb af                	jmp    80102c6d <mpinit+0x4e>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102cbe:	85 db                	test   %ebx,%ebx
80102cc0:	74 26                	je     80102ce8 <mpinit+0xc9>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102cc5:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102cc9:	74 15                	je     80102ce0 <mpinit+0xc1>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ccb:	b8 70 00 00 00       	mov    $0x70,%eax
80102cd0:	ba 22 00 00 00       	mov    $0x22,%edx
80102cd5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd6:	ba 23 00 00 00       	mov    $0x23,%edx
80102cdb:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102cdc:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cdf:	ee                   	out    %al,(%dx)
  }
}
80102ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ce3:	5b                   	pop    %ebx
80102ce4:	5e                   	pop    %esi
80102ce5:	5f                   	pop    %edi
80102ce6:	5d                   	pop    %ebp
80102ce7:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102ce8:	83 ec 0c             	sub    $0xc,%esp
80102ceb:	68 3c 6c 10 80       	push   $0x80106c3c
80102cf0:	e8 53 d6 ff ff       	call   80100348 <panic>

80102cf5 <picinit>:
80102cf5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102cfa:	ba 21 00 00 00       	mov    $0x21,%edx
80102cff:	ee                   	out    %al,(%dx)
80102d00:	ba a1 00 00 00       	mov    $0xa1,%edx
80102d05:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102d06:	c3                   	ret    

80102d07 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102d07:	55                   	push   %ebp
80102d08:	89 e5                	mov    %esp,%ebp
80102d0a:	57                   	push   %edi
80102d0b:	56                   	push   %esi
80102d0c:	53                   	push   %ebx
80102d0d:	83 ec 0c             	sub    $0xc,%esp
80102d10:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d13:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102d16:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102d1c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102d22:	e8 f6 de ff ff       	call   80100c1d <filealloc>
80102d27:	89 03                	mov    %eax,(%ebx)
80102d29:	85 c0                	test   %eax,%eax
80102d2b:	0f 84 88 00 00 00    	je     80102db9 <pipealloc+0xb2>
80102d31:	e8 e7 de ff ff       	call   80100c1d <filealloc>
80102d36:	89 06                	mov    %eax,(%esi)
80102d38:	85 c0                	test   %eax,%eax
80102d3a:	74 7d                	je     80102db9 <pipealloc+0xb2>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102d3c:	e8 62 f3 ff ff       	call   801020a3 <kalloc>
80102d41:	89 c7                	mov    %eax,%edi
80102d43:	85 c0                	test   %eax,%eax
80102d45:	74 72                	je     80102db9 <pipealloc+0xb2>
    goto bad;
  p->readopen = 1;
80102d47:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102d4e:	00 00 00 
  p->writeopen = 1;
80102d51:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102d58:	00 00 00 
  p->nwrite = 0;
80102d5b:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102d62:	00 00 00 
  p->nread = 0;
80102d65:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102d6c:	00 00 00 
  initlock(&p->lock, "pipe");
80102d6f:	83 ec 08             	sub    $0x8,%esp
80102d72:	68 5b 6c 10 80       	push   $0x80106c5b
80102d77:	50                   	push   %eax
80102d78:	e8 08 0e 00 00       	call   80103b85 <initlock>
  (*f0)->type = FD_PIPE;
80102d7d:	8b 03                	mov    (%ebx),%eax
80102d7f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102d85:	8b 03                	mov    (%ebx),%eax
80102d87:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102d8b:	8b 03                	mov    (%ebx),%eax
80102d8d:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102d91:	8b 03                	mov    (%ebx),%eax
80102d93:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102d96:	8b 06                	mov    (%esi),%eax
80102d98:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102d9e:	8b 06                	mov    (%esi),%eax
80102da0:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102da4:	8b 06                	mov    (%esi),%eax
80102da6:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102daa:	8b 06                	mov    (%esi),%eax
80102dac:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102daf:	83 c4 10             	add    $0x10,%esp
80102db2:	b8 00 00 00 00       	mov    $0x0,%eax
80102db7:	eb 29                	jmp    80102de2 <pipealloc+0xdb>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102db9:	8b 03                	mov    (%ebx),%eax
80102dbb:	85 c0                	test   %eax,%eax
80102dbd:	74 0c                	je     80102dcb <pipealloc+0xc4>
    fileclose(*f0);
80102dbf:	83 ec 0c             	sub    $0xc,%esp
80102dc2:	50                   	push   %eax
80102dc3:	e8 fb de ff ff       	call   80100cc3 <fileclose>
80102dc8:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102dcb:	8b 06                	mov    (%esi),%eax
80102dcd:	85 c0                	test   %eax,%eax
80102dcf:	74 19                	je     80102dea <pipealloc+0xe3>
    fileclose(*f1);
80102dd1:	83 ec 0c             	sub    $0xc,%esp
80102dd4:	50                   	push   %eax
80102dd5:	e8 e9 de ff ff       	call   80100cc3 <fileclose>
80102dda:	83 c4 10             	add    $0x10,%esp
  return -1;
80102ddd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102de2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102de5:	5b                   	pop    %ebx
80102de6:	5e                   	pop    %esi
80102de7:	5f                   	pop    %edi
80102de8:	5d                   	pop    %ebp
80102de9:	c3                   	ret    
  return -1;
80102dea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102def:	eb f1                	jmp    80102de2 <pipealloc+0xdb>

80102df1 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102df1:	55                   	push   %ebp
80102df2:	89 e5                	mov    %esp,%ebp
80102df4:	53                   	push   %ebx
80102df5:	83 ec 10             	sub    $0x10,%esp
80102df8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102dfb:	53                   	push   %ebx
80102dfc:	e8 c0 0e 00 00       	call   80103cc1 <acquire>
  if(writable){
80102e01:	83 c4 10             	add    $0x10,%esp
80102e04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102e08:	74 3f                	je     80102e49 <pipeclose+0x58>
    p->writeopen = 0;
80102e0a:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102e11:	00 00 00 
    wakeup(&p->nread);
80102e14:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e1a:	83 ec 0c             	sub    $0xc,%esp
80102e1d:	50                   	push   %eax
80102e1e:	e8 53 0a 00 00       	call   80103876 <wakeup>
80102e23:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102e26:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102e2d:	75 09                	jne    80102e38 <pipeclose+0x47>
80102e2f:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102e36:	74 2f                	je     80102e67 <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102e38:	83 ec 0c             	sub    $0xc,%esp
80102e3b:	53                   	push   %ebx
80102e3c:	e8 e5 0e 00 00       	call   80103d26 <release>
80102e41:	83 c4 10             	add    $0x10,%esp
}
80102e44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e47:	c9                   	leave  
80102e48:	c3                   	ret    
    p->readopen = 0;
80102e49:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102e50:	00 00 00 
    wakeup(&p->nwrite);
80102e53:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102e59:	83 ec 0c             	sub    $0xc,%esp
80102e5c:	50                   	push   %eax
80102e5d:	e8 14 0a 00 00       	call   80103876 <wakeup>
80102e62:	83 c4 10             	add    $0x10,%esp
80102e65:	eb bf                	jmp    80102e26 <pipeclose+0x35>
    release(&p->lock);
80102e67:	83 ec 0c             	sub    $0xc,%esp
80102e6a:	53                   	push   %ebx
80102e6b:	e8 b6 0e 00 00       	call   80103d26 <release>
    kfree((char*)p);
80102e70:	89 1c 24             	mov    %ebx,(%esp)
80102e73:	e8 14 f1 ff ff       	call   80101f8c <kfree>
80102e78:	83 c4 10             	add    $0x10,%esp
80102e7b:	eb c7                	jmp    80102e44 <pipeclose+0x53>

80102e7d <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102e7d:	55                   	push   %ebp
80102e7e:	89 e5                	mov    %esp,%ebp
80102e80:	57                   	push   %edi
80102e81:	56                   	push   %esi
80102e82:	53                   	push   %ebx
80102e83:	83 ec 18             	sub    $0x18,%esp
80102e86:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e89:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  acquire(&p->lock);
80102e8c:	53                   	push   %ebx
80102e8d:	e8 2f 0e 00 00       	call   80103cc1 <acquire>
  for(i = 0; i < n; i++){
80102e92:	83 c4 10             	add    $0x10,%esp
80102e95:	bf 00 00 00 00       	mov    $0x0,%edi
80102e9a:	39 f7                	cmp    %esi,%edi
80102e9c:	7c 40                	jl     80102ede <pipewrite+0x61>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102e9e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102ea4:	83 ec 0c             	sub    $0xc,%esp
80102ea7:	50                   	push   %eax
80102ea8:	e8 c9 09 00 00       	call   80103876 <wakeup>
  release(&p->lock);
80102ead:	89 1c 24             	mov    %ebx,(%esp)
80102eb0:	e8 71 0e 00 00       	call   80103d26 <release>
  return n;
80102eb5:	83 c4 10             	add    $0x10,%esp
80102eb8:	89 f0                	mov    %esi,%eax
80102eba:	eb 5c                	jmp    80102f18 <pipewrite+0x9b>
      wakeup(&p->nread);
80102ebc:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102ec2:	83 ec 0c             	sub    $0xc,%esp
80102ec5:	50                   	push   %eax
80102ec6:	e8 ab 09 00 00       	call   80103876 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102ecb:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102ed1:	83 c4 08             	add    $0x8,%esp
80102ed4:	53                   	push   %ebx
80102ed5:	50                   	push   %eax
80102ed6:	e8 33 08 00 00       	call   8010370e <sleep>
80102edb:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102ede:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102ee4:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102eea:	05 00 02 00 00       	add    $0x200,%eax
80102eef:	39 c2                	cmp    %eax,%edx
80102ef1:	75 2d                	jne    80102f20 <pipewrite+0xa3>
      if(p->readopen == 0 || myproc()->killed){
80102ef3:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102efa:	74 0b                	je     80102f07 <pipewrite+0x8a>
80102efc:	e8 c1 02 00 00       	call   801031c2 <myproc>
80102f01:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102f05:	74 b5                	je     80102ebc <pipewrite+0x3f>
        release(&p->lock);
80102f07:	83 ec 0c             	sub    $0xc,%esp
80102f0a:	53                   	push   %ebx
80102f0b:	e8 16 0e 00 00       	call   80103d26 <release>
        return -1;
80102f10:	83 c4 10             	add    $0x10,%esp
80102f13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f1b:	5b                   	pop    %ebx
80102f1c:	5e                   	pop    %esi
80102f1d:	5f                   	pop    %edi
80102f1e:	5d                   	pop    %ebp
80102f1f:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102f20:	8d 42 01             	lea    0x1(%edx),%eax
80102f23:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102f29:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f32:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
80102f36:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80102f3a:	83 c7 01             	add    $0x1,%edi
80102f3d:	e9 58 ff ff ff       	jmp    80102e9a <pipewrite+0x1d>

80102f42 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80102f42:	55                   	push   %ebp
80102f43:	89 e5                	mov    %esp,%ebp
80102f45:	57                   	push   %edi
80102f46:	56                   	push   %esi
80102f47:	53                   	push   %ebx
80102f48:	83 ec 18             	sub    $0x18,%esp
80102f4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f4e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80102f51:	53                   	push   %ebx
80102f52:	e8 6a 0d 00 00       	call   80103cc1 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102f57:	83 c4 10             	add    $0x10,%esp
80102f5a:	eb 13                	jmp    80102f6f <piperead+0x2d>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80102f5c:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f62:	83 ec 08             	sub    $0x8,%esp
80102f65:	53                   	push   %ebx
80102f66:	50                   	push   %eax
80102f67:	e8 a2 07 00 00       	call   8010370e <sleep>
80102f6c:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102f6f:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102f75:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80102f7b:	75 78                	jne    80102ff5 <piperead+0xb3>
80102f7d:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80102f83:	85 f6                	test   %esi,%esi
80102f85:	74 37                	je     80102fbe <piperead+0x7c>
    if(myproc()->killed){
80102f87:	e8 36 02 00 00       	call   801031c2 <myproc>
80102f8c:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102f90:	74 ca                	je     80102f5c <piperead+0x1a>
      release(&p->lock);
80102f92:	83 ec 0c             	sub    $0xc,%esp
80102f95:	53                   	push   %ebx
80102f96:	e8 8b 0d 00 00       	call   80103d26 <release>
      return -1;
80102f9b:	83 c4 10             	add    $0x10,%esp
80102f9e:	be ff ff ff ff       	mov    $0xffffffff,%esi
80102fa3:	eb 46                	jmp    80102feb <piperead+0xa9>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80102fa5:	8d 50 01             	lea    0x1(%eax),%edx
80102fa8:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80102fae:	25 ff 01 00 00       	and    $0x1ff,%eax
80102fb3:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80102fb8:	88 04 37             	mov    %al,(%edi,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80102fbb:	83 c6 01             	add    $0x1,%esi
80102fbe:	3b 75 10             	cmp    0x10(%ebp),%esi
80102fc1:	7d 0e                	jge    80102fd1 <piperead+0x8f>
    if(p->nread == p->nwrite)
80102fc3:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102fc9:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80102fcf:	75 d4                	jne    80102fa5 <piperead+0x63>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80102fd1:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102fd7:	83 ec 0c             	sub    $0xc,%esp
80102fda:	50                   	push   %eax
80102fdb:	e8 96 08 00 00       	call   80103876 <wakeup>
  release(&p->lock);
80102fe0:	89 1c 24             	mov    %ebx,(%esp)
80102fe3:	e8 3e 0d 00 00       	call   80103d26 <release>
  return i;
80102fe8:	83 c4 10             	add    $0x10,%esp
}
80102feb:	89 f0                	mov    %esi,%eax
80102fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ff0:	5b                   	pop    %ebx
80102ff1:	5e                   	pop    %esi
80102ff2:	5f                   	pop    %edi
80102ff3:	5d                   	pop    %ebp
80102ff4:	c3                   	ret    
80102ff5:	be 00 00 00 00       	mov    $0x0,%esi
80102ffa:	eb c2                	jmp    80102fbe <piperead+0x7c>

80102ffc <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80102ffc:	ba 54 1d 11 80       	mov    $0x80111d54,%edx
80103001:	eb 06                	jmp    80103009 <wakeup1+0xd>
80103003:	81 c2 84 00 00 00    	add    $0x84,%edx
80103009:	81 fa 54 3e 11 80    	cmp    $0x80113e54,%edx
8010300f:	73 14                	jae    80103025 <wakeup1+0x29>
    if(p->state == SLEEPING && p->chan == chan)
80103011:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103015:	75 ec                	jne    80103003 <wakeup1+0x7>
80103017:	39 42 20             	cmp    %eax,0x20(%edx)
8010301a:	75 e7                	jne    80103003 <wakeup1+0x7>
      p->state = RUNNABLE;
8010301c:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103023:	eb de                	jmp    80103003 <wakeup1+0x7>
}
80103025:	c3                   	ret    

80103026 <allocproc>:
{
80103026:	55                   	push   %ebp
80103027:	89 e5                	mov    %esp,%ebp
80103029:	53                   	push   %ebx
8010302a:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010302d:	68 20 1d 11 80       	push   $0x80111d20
80103032:	e8 8a 0c 00 00       	call   80103cc1 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103037:	83 c4 10             	add    $0x10,%esp
8010303a:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
8010303f:	eb 06                	jmp    80103047 <allocproc+0x21>
80103041:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103047:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
8010304d:	73 7d                	jae    801030cc <allocproc+0xa6>
    if(p->state == UNUSED)
8010304f:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
80103053:	75 ec                	jne    80103041 <allocproc+0x1b>
  p->state = EMBRYO;
80103055:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
8010305c:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103061:	8d 50 01             	lea    0x1(%eax),%edx
80103064:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010306a:	89 43 10             	mov    %eax,0x10(%ebx)
  p->tickets = 1;
8010306d:	c7 43 7c 01 00 00 00 	movl   $0x1,0x7c(%ebx)
  release(&ptable.lock);
80103074:	83 ec 0c             	sub    $0xc,%esp
80103077:	68 20 1d 11 80       	push   $0x80111d20
8010307c:	e8 a5 0c 00 00       	call   80103d26 <release>
  if((p->kstack = kalloc()) == 0){
80103081:	e8 1d f0 ff ff       	call   801020a3 <kalloc>
80103086:	89 43 08             	mov    %eax,0x8(%ebx)
80103089:	83 c4 10             	add    $0x10,%esp
8010308c:	85 c0                	test   %eax,%eax
8010308e:	74 53                	je     801030e3 <allocproc+0xbd>
  sp -= sizeof *p->tf;
80103090:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
80103096:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103099:	c7 80 b0 0f 00 00 39 	movl   $0x80104e39,0xfb0(%eax)
801030a0:	4e 10 80 
  sp -= sizeof *p->context;
801030a3:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
801030a8:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801030ab:	83 ec 04             	sub    $0x4,%esp
801030ae:	6a 14                	push   $0x14
801030b0:	6a 00                	push   $0x0
801030b2:	50                   	push   %eax
801030b3:	e8 b5 0c 00 00       	call   80103d6d <memset>
  p->context->eip = (uint)forkret;
801030b8:	8b 43 1c             	mov    0x1c(%ebx),%eax
801030bb:	c7 40 10 ee 30 10 80 	movl   $0x801030ee,0x10(%eax)
  return p;
801030c2:	83 c4 10             	add    $0x10,%esp
}
801030c5:	89 d8                	mov    %ebx,%eax
801030c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801030ca:	c9                   	leave  
801030cb:	c3                   	ret    
  release(&ptable.lock);
801030cc:	83 ec 0c             	sub    $0xc,%esp
801030cf:	68 20 1d 11 80       	push   $0x80111d20
801030d4:	e8 4d 0c 00 00       	call   80103d26 <release>
  return 0;
801030d9:	83 c4 10             	add    $0x10,%esp
801030dc:	bb 00 00 00 00       	mov    $0x0,%ebx
801030e1:	eb e2                	jmp    801030c5 <allocproc+0x9f>
    p->state = UNUSED;
801030e3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801030ea:	89 c3                	mov    %eax,%ebx
801030ec:	eb d7                	jmp    801030c5 <allocproc+0x9f>

801030ee <forkret>:
{
801030ee:	55                   	push   %ebp
801030ef:	89 e5                	mov    %esp,%ebp
801030f1:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
801030f4:	68 20 1d 11 80       	push   $0x80111d20
801030f9:	e8 28 0c 00 00       	call   80103d26 <release>
  if (first) {
801030fe:	83 c4 10             	add    $0x10,%esp
80103101:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
80103108:	75 02                	jne    8010310c <forkret+0x1e>
}
8010310a:	c9                   	leave  
8010310b:	c3                   	ret    
    first = 0;
8010310c:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103113:	00 00 00 
    iinit(ROOTDEV);
80103116:	83 ec 0c             	sub    $0xc,%esp
80103119:	6a 01                	push   $0x1
8010311b:	e8 ba e1 ff ff       	call   801012da <iinit>
    initlog(ROOTDEV);
80103120:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103127:	e8 09 f6 ff ff       	call   80102735 <initlog>
8010312c:	83 c4 10             	add    $0x10,%esp
}
8010312f:	eb d9                	jmp    8010310a <forkret+0x1c>

80103131 <pinit>:
{
80103131:	55                   	push   %ebp
80103132:	89 e5                	mov    %esp,%ebp
80103134:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103137:	68 60 6c 10 80       	push   $0x80106c60
8010313c:	68 20 1d 11 80       	push   $0x80111d20
80103141:	e8 3f 0a 00 00       	call   80103b85 <initlock>
}
80103146:	83 c4 10             	add    $0x10,%esp
80103149:	c9                   	leave  
8010314a:	c3                   	ret    

8010314b <mycpu>:
{
8010314b:	55                   	push   %ebp
8010314c:	89 e5                	mov    %esp,%ebp
8010314e:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103151:	9c                   	pushf  
80103152:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103153:	f6 c4 02             	test   $0x2,%ah
80103156:	75 28                	jne    80103180 <mycpu+0x35>
  apicid = lapicid();
80103158:	e8 03 f2 ff ff       	call   80102360 <lapicid>
  for (i = 0; i < ncpu; ++i) {
8010315d:	ba 00 00 00 00       	mov    $0x0,%edx
80103162:	39 15 84 17 11 80    	cmp    %edx,0x80111784
80103168:	7e 23                	jle    8010318d <mycpu+0x42>
    if (cpus[i].apicid == apicid)
8010316a:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103170:	0f b6 89 a0 17 11 80 	movzbl -0x7feee860(%ecx),%ecx
80103177:	39 c1                	cmp    %eax,%ecx
80103179:	74 1f                	je     8010319a <mycpu+0x4f>
  for (i = 0; i < ncpu; ++i) {
8010317b:	83 c2 01             	add    $0x1,%edx
8010317e:	eb e2                	jmp    80103162 <mycpu+0x17>
    panic("mycpu called with interrupts enabled\n");
80103180:	83 ec 0c             	sub    $0xc,%esp
80103183:	68 44 6d 10 80       	push   $0x80106d44
80103188:	e8 bb d1 ff ff       	call   80100348 <panic>
  panic("unknown apicid\n");
8010318d:	83 ec 0c             	sub    $0xc,%esp
80103190:	68 67 6c 10 80       	push   $0x80106c67
80103195:	e8 ae d1 ff ff       	call   80100348 <panic>
      return &cpus[i];
8010319a:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801031a0:	05 a0 17 11 80       	add    $0x801117a0,%eax
}
801031a5:	c9                   	leave  
801031a6:	c3                   	ret    

801031a7 <cpuid>:
cpuid() {
801031a7:	55                   	push   %ebp
801031a8:	89 e5                	mov    %esp,%ebp
801031aa:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801031ad:	e8 99 ff ff ff       	call   8010314b <mycpu>
801031b2:	2d a0 17 11 80       	sub    $0x801117a0,%eax
801031b7:	c1 f8 04             	sar    $0x4,%eax
801031ba:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801031c0:	c9                   	leave  
801031c1:	c3                   	ret    

801031c2 <myproc>:
myproc(void) {
801031c2:	55                   	push   %ebp
801031c3:	89 e5                	mov    %esp,%ebp
801031c5:	53                   	push   %ebx
801031c6:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801031c9:	e8 18 0a 00 00       	call   80103be6 <pushcli>
  c = mycpu();
801031ce:	e8 78 ff ff ff       	call   8010314b <mycpu>
  p = c->proc;
801031d3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801031d9:	e8 44 0a 00 00       	call   80103c22 <popcli>
}
801031de:	89 d8                	mov    %ebx,%eax
801031e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031e3:	c9                   	leave  
801031e4:	c3                   	ret    

801031e5 <userinit>:
{
801031e5:	55                   	push   %ebp
801031e6:	89 e5                	mov    %esp,%ebp
801031e8:	53                   	push   %ebx
801031e9:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801031ec:	e8 35 fe ff ff       	call   80103026 <allocproc>
801031f1:	89 c3                	mov    %eax,%ebx
  initproc = p;
801031f3:	a3 54 3e 11 80       	mov    %eax,0x80113e54
  if((p->pgdir = setupkvm()) == 0)
801031f8:	e8 d6 32 00 00       	call   801064d3 <setupkvm>
801031fd:	89 43 04             	mov    %eax,0x4(%ebx)
80103200:	85 c0                	test   %eax,%eax
80103202:	0f 84 b8 00 00 00    	je     801032c0 <userinit+0xdb>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103208:	83 ec 04             	sub    $0x4,%esp
8010320b:	68 2c 00 00 00       	push   $0x2c
80103210:	68 60 a4 10 80       	push   $0x8010a460
80103215:	50                   	push   %eax
80103216:	e8 c8 2f 00 00       	call   801061e3 <inituvm>
  p->sz = PGSIZE;
8010321b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103221:	8b 43 18             	mov    0x18(%ebx),%eax
80103224:	83 c4 0c             	add    $0xc,%esp
80103227:	6a 4c                	push   $0x4c
80103229:	6a 00                	push   $0x0
8010322b:	50                   	push   %eax
8010322c:	e8 3c 0b 00 00       	call   80103d6d <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103231:	8b 43 18             	mov    0x18(%ebx),%eax
80103234:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010323a:	8b 43 18             	mov    0x18(%ebx),%eax
8010323d:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103243:	8b 43 18             	mov    0x18(%ebx),%eax
80103246:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010324a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010324e:	8b 43 18             	mov    0x18(%ebx),%eax
80103251:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103255:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103259:	8b 43 18             	mov    0x18(%ebx),%eax
8010325c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103263:	8b 43 18             	mov    0x18(%ebx),%eax
80103266:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010326d:	8b 43 18             	mov    0x18(%ebx),%eax
80103270:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103277:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010327a:	83 c4 0c             	add    $0xc,%esp
8010327d:	6a 10                	push   $0x10
8010327f:	68 90 6c 10 80       	push   $0x80106c90
80103284:	50                   	push   %eax
80103285:	e8 4f 0c 00 00       	call   80103ed9 <safestrcpy>
  p->cwd = namei("/");
8010328a:	c7 04 24 99 6c 10 80 	movl   $0x80106c99,(%esp)
80103291:	e8 37 e9 ff ff       	call   80101bcd <namei>
80103296:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103299:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801032a0:	e8 1c 0a 00 00       	call   80103cc1 <acquire>
  p->state = RUNNABLE;
801032a5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801032ac:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
801032b3:	e8 6e 0a 00 00       	call   80103d26 <release>
}
801032b8:	83 c4 10             	add    $0x10,%esp
801032bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801032be:	c9                   	leave  
801032bf:	c3                   	ret    
    panic("userinit: out of memory?");
801032c0:	83 ec 0c             	sub    $0xc,%esp
801032c3:	68 77 6c 10 80       	push   $0x80106c77
801032c8:	e8 7b d0 ff ff       	call   80100348 <panic>

801032cd <growproc>:
{
801032cd:	55                   	push   %ebp
801032ce:	89 e5                	mov    %esp,%ebp
801032d0:	56                   	push   %esi
801032d1:	53                   	push   %ebx
801032d2:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801032d5:	e8 e8 fe ff ff       	call   801031c2 <myproc>
801032da:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801032dc:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801032de:	85 f6                	test   %esi,%esi
801032e0:	7f 1c                	jg     801032fe <growproc+0x31>
  } else if(n < 0){
801032e2:	78 37                	js     8010331b <growproc+0x4e>
  curproc->sz = sz;
801032e4:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801032e6:	83 ec 0c             	sub    $0xc,%esp
801032e9:	53                   	push   %ebx
801032ea:	e8 94 2d 00 00       	call   80106083 <switchuvm>
  return 0;
801032ef:	83 c4 10             	add    $0x10,%esp
801032f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801032f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801032fa:	5b                   	pop    %ebx
801032fb:	5e                   	pop    %esi
801032fc:	5d                   	pop    %ebp
801032fd:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801032fe:	83 ec 04             	sub    $0x4,%esp
80103301:	01 c6                	add    %eax,%esi
80103303:	56                   	push   %esi
80103304:	50                   	push   %eax
80103305:	ff 73 04             	push   0x4(%ebx)
80103308:	e8 6c 30 00 00       	call   80106379 <allocuvm>
8010330d:	83 c4 10             	add    $0x10,%esp
80103310:	85 c0                	test   %eax,%eax
80103312:	75 d0                	jne    801032e4 <growproc+0x17>
      return -1;
80103314:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103319:	eb dc                	jmp    801032f7 <growproc+0x2a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010331b:	83 ec 04             	sub    $0x4,%esp
8010331e:	01 c6                	add    %eax,%esi
80103320:	56                   	push   %esi
80103321:	50                   	push   %eax
80103322:	ff 73 04             	push   0x4(%ebx)
80103325:	e8 bd 2f 00 00       	call   801062e7 <deallocuvm>
8010332a:	83 c4 10             	add    $0x10,%esp
8010332d:	85 c0                	test   %eax,%eax
8010332f:	75 b3                	jne    801032e4 <growproc+0x17>
      return -1;
80103331:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103336:	eb bf                	jmp    801032f7 <growproc+0x2a>

80103338 <fork>:
{
80103338:	55                   	push   %ebp
80103339:	89 e5                	mov    %esp,%ebp
8010333b:	57                   	push   %edi
8010333c:	56                   	push   %esi
8010333d:	53                   	push   %ebx
8010333e:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103341:	e8 7c fe ff ff       	call   801031c2 <myproc>
80103346:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103348:	e8 d9 fc ff ff       	call   80103026 <allocproc>
8010334d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103350:	85 c0                	test   %eax,%eax
80103352:	0f 84 e6 00 00 00    	je     8010343e <fork+0x106>
80103358:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010335a:	83 ec 08             	sub    $0x8,%esp
8010335d:	ff 33                	push   (%ebx)
8010335f:	ff 73 04             	push   0x4(%ebx)
80103362:	e8 1d 32 00 00       	call   80106584 <copyuvm>
80103367:	89 47 04             	mov    %eax,0x4(%edi)
8010336a:	83 c4 10             	add    $0x10,%esp
8010336d:	85 c0                	test   %eax,%eax
8010336f:	74 2a                	je     8010339b <fork+0x63>
  np->sz = curproc->sz;
80103371:	8b 03                	mov    (%ebx),%eax
80103373:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103376:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103378:	89 c8                	mov    %ecx,%eax
8010337a:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010337d:	8b 73 18             	mov    0x18(%ebx),%esi
80103380:	8b 79 18             	mov    0x18(%ecx),%edi
80103383:	b9 13 00 00 00       	mov    $0x13,%ecx
80103388:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
8010338a:	8b 40 18             	mov    0x18(%eax),%eax
8010338d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103394:	be 00 00 00 00       	mov    $0x0,%esi
80103399:	eb 29                	jmp    801033c4 <fork+0x8c>
    kfree(np->kstack);
8010339b:	83 ec 0c             	sub    $0xc,%esp
8010339e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801033a1:	ff 73 08             	push   0x8(%ebx)
801033a4:	e8 e3 eb ff ff       	call   80101f8c <kfree>
    np->kstack = 0;
801033a9:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801033b0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801033b7:	83 c4 10             	add    $0x10,%esp
801033ba:	be ff ff ff ff       	mov    $0xffffffff,%esi
801033bf:	eb 73                	jmp    80103434 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
801033c1:	83 c6 01             	add    $0x1,%esi
801033c4:	83 fe 0f             	cmp    $0xf,%esi
801033c7:	7f 1d                	jg     801033e6 <fork+0xae>
    if(curproc->ofile[i])
801033c9:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801033cd:	85 c0                	test   %eax,%eax
801033cf:	74 f0                	je     801033c1 <fork+0x89>
      np->ofile[i] = filedup(curproc->ofile[i]);
801033d1:	83 ec 0c             	sub    $0xc,%esp
801033d4:	50                   	push   %eax
801033d5:	e8 a4 d8 ff ff       	call   80100c7e <filedup>
801033da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801033dd:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
801033e1:	83 c4 10             	add    $0x10,%esp
801033e4:	eb db                	jmp    801033c1 <fork+0x89>
  np->cwd = idup(curproc->cwd);
801033e6:	83 ec 0c             	sub    $0xc,%esp
801033e9:	ff 73 68             	push   0x68(%ebx)
801033ec:	e8 4e e1 ff ff       	call   8010153f <idup>
801033f1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801033f4:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801033f7:	8d 53 6c             	lea    0x6c(%ebx),%edx
801033fa:	8d 47 6c             	lea    0x6c(%edi),%eax
801033fd:	83 c4 0c             	add    $0xc,%esp
80103400:	6a 10                	push   $0x10
80103402:	52                   	push   %edx
80103403:	50                   	push   %eax
80103404:	e8 d0 0a 00 00       	call   80103ed9 <safestrcpy>
  pid = np->pid;
80103409:	8b 77 10             	mov    0x10(%edi),%esi
  acquire(&ptable.lock);
8010340c:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103413:	e8 a9 08 00 00       	call   80103cc1 <acquire>
  np->state = RUNNABLE;
80103418:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  np->tickets = curproc->tickets;
8010341f:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103422:	89 47 7c             	mov    %eax,0x7c(%edi)
  release(&ptable.lock);
80103425:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010342c:	e8 f5 08 00 00       	call   80103d26 <release>
  return pid;
80103431:	83 c4 10             	add    $0x10,%esp
}
80103434:	89 f0                	mov    %esi,%eax
80103436:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103439:	5b                   	pop    %ebx
8010343a:	5e                   	pop    %esi
8010343b:	5f                   	pop    %edi
8010343c:	5d                   	pop    %ebp
8010343d:	c3                   	ret    
    return -1;
8010343e:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103443:	eb ef                	jmp    80103434 <fork+0xfc>

80103445 <scheduler>:
{
80103445:	55                   	push   %ebp
80103446:	89 e5                	mov    %esp,%ebp
80103448:	57                   	push   %edi
80103449:	56                   	push   %esi
8010344a:	53                   	push   %ebx
8010344b:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
8010344e:	e8 f8 fc ff ff       	call   8010314b <mycpu>
80103453:	89 c7                	mov    %eax,%edi
  c->proc = 0;
80103455:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010345c:	00 00 00 
8010345f:	eb 6e                	jmp    801034cf <scheduler+0x8a>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103461:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103467:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
8010346d:	73 4a                	jae    801034b9 <scheduler+0x74>
      if(p->state != RUNNABLE || p->tickets != 1)
8010346f:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103473:	75 ec                	jne    80103461 <scheduler+0x1c>
80103475:	8b 73 7c             	mov    0x7c(%ebx),%esi
80103478:	83 fe 01             	cmp    $0x1,%esi
8010347b:	75 e4                	jne    80103461 <scheduler+0x1c>
      c->proc = p;
8010347d:	89 9f ac 00 00 00    	mov    %ebx,0xac(%edi)
      switchuvm(p);
80103483:	83 ec 0c             	sub    $0xc,%esp
80103486:	53                   	push   %ebx
80103487:	e8 f7 2b 00 00       	call   80106083 <switchuvm>
      p->state = RUNNING;
8010348c:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103493:	83 c4 08             	add    $0x8,%esp
80103496:	ff 73 1c             	push   0x1c(%ebx)
80103499:	8d 47 04             	lea    0x4(%edi),%eax
8010349c:	50                   	push   %eax
8010349d:	e8 8c 0a 00 00       	call   80103f2e <swtch>
      switchkvm();
801034a2:	e8 ce 2b 00 00       	call   80106075 <switchkvm>
      c->proc = 0;
801034a7:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
801034ae:	00 00 00 
801034b1:	83 c4 10             	add    $0x10,%esp
      high_priority = 1;
801034b4:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801034b7:	eb a8                	jmp    80103461 <scheduler+0x1c>
    release(&ptable.lock);
801034b9:	83 ec 0c             	sub    $0xc,%esp
801034bc:	68 20 1d 11 80       	push   $0x80111d20
801034c1:	e8 60 08 00 00       	call   80103d26 <release>
    if(high_priority == 1)
801034c6:	83 c4 10             	add    $0x10,%esp
801034c9:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
801034cd:	75 22                	jne    801034f1 <scheduler+0xac>
  asm volatile("sti");
801034cf:	fb                   	sti    
    acquire(&ptable.lock);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	68 20 1d 11 80       	push   $0x80111d20
801034d8:	e8 e4 07 00 00       	call   80103cc1 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801034dd:	83 c4 10             	add    $0x10,%esp
    int high_priority = 0;
801034e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801034e7:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801034ec:	e9 76 ff ff ff       	jmp    80103467 <scheduler+0x22>
    acquire(&ptable.lock);
801034f1:	83 ec 0c             	sub    $0xc,%esp
801034f4:	68 20 1d 11 80       	push   $0x80111d20
801034f9:	e8 c3 07 00 00       	call   80103cc1 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801034fe:	83 c4 10             	add    $0x10,%esp
80103501:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103506:	eb 06                	jmp    8010350e <scheduler+0xc9>
80103508:	81 c3 84 00 00 00    	add    $0x84,%ebx
8010350e:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
80103514:	73 45                	jae    8010355b <scheduler+0x116>
      if(p->state != RUNNABLE || p->tickets != 0)
80103516:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010351a:	75 ec                	jne    80103508 <scheduler+0xc3>
8010351c:	83 7b 7c 00          	cmpl   $0x0,0x7c(%ebx)
80103520:	75 e6                	jne    80103508 <scheduler+0xc3>
      c->proc = p;
80103522:	89 9f ac 00 00 00    	mov    %ebx,0xac(%edi)
      switchuvm(p);
80103528:	83 ec 0c             	sub    $0xc,%esp
8010352b:	53                   	push   %ebx
8010352c:	e8 52 2b 00 00       	call   80106083 <switchuvm>
      p->state = RUNNING;
80103531:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103538:	83 c4 08             	add    $0x8,%esp
8010353b:	ff 73 1c             	push   0x1c(%ebx)
8010353e:	8d 47 04             	lea    0x4(%edi),%eax
80103541:	50                   	push   %eax
80103542:	e8 e7 09 00 00       	call   80103f2e <swtch>
      switchkvm();
80103547:	e8 29 2b 00 00       	call   80106075 <switchkvm>
      c->proc = 0;
8010354c:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80103553:	00 00 00 
80103556:	83 c4 10             	add    $0x10,%esp
80103559:	eb ad                	jmp    80103508 <scheduler+0xc3>
    release(&ptable.lock);
8010355b:	83 ec 0c             	sub    $0xc,%esp
8010355e:	68 20 1d 11 80       	push   $0x80111d20
80103563:	e8 be 07 00 00       	call   80103d26 <release>
80103568:	83 c4 10             	add    $0x10,%esp
8010356b:	e9 5f ff ff ff       	jmp    801034cf <scheduler+0x8a>

80103570 <sched>:
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	56                   	push   %esi
80103574:	53                   	push   %ebx
  struct proc *p = myproc();
80103575:	e8 48 fc ff ff       	call   801031c2 <myproc>
8010357a:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
8010357c:	83 ec 0c             	sub    $0xc,%esp
8010357f:	68 20 1d 11 80       	push   $0x80111d20
80103584:	e8 f9 06 00 00       	call   80103c82 <holding>
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	85 c0                	test   %eax,%eax
8010358e:	74 4f                	je     801035df <sched+0x6f>
  if(mycpu()->ncli != 1)
80103590:	e8 b6 fb ff ff       	call   8010314b <mycpu>
80103595:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010359c:	75 4e                	jne    801035ec <sched+0x7c>
  if(p->state == RUNNING)
8010359e:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801035a2:	74 55                	je     801035f9 <sched+0x89>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801035a4:	9c                   	pushf  
801035a5:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801035a6:	f6 c4 02             	test   $0x2,%ah
801035a9:	75 5b                	jne    80103606 <sched+0x96>
  intena = mycpu()->intena;
801035ab:	e8 9b fb ff ff       	call   8010314b <mycpu>
801035b0:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801035b6:	e8 90 fb ff ff       	call   8010314b <mycpu>
801035bb:	83 ec 08             	sub    $0x8,%esp
801035be:	ff 70 04             	push   0x4(%eax)
801035c1:	83 c3 1c             	add    $0x1c,%ebx
801035c4:	53                   	push   %ebx
801035c5:	e8 64 09 00 00       	call   80103f2e <swtch>
  mycpu()->intena = intena;
801035ca:	e8 7c fb ff ff       	call   8010314b <mycpu>
801035cf:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801035d5:	83 c4 10             	add    $0x10,%esp
801035d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035db:	5b                   	pop    %ebx
801035dc:	5e                   	pop    %esi
801035dd:	5d                   	pop    %ebp
801035de:	c3                   	ret    
    panic("sched ptable.lock");
801035df:	83 ec 0c             	sub    $0xc,%esp
801035e2:	68 9b 6c 10 80       	push   $0x80106c9b
801035e7:	e8 5c cd ff ff       	call   80100348 <panic>
    panic("sched locks");
801035ec:	83 ec 0c             	sub    $0xc,%esp
801035ef:	68 ad 6c 10 80       	push   $0x80106cad
801035f4:	e8 4f cd ff ff       	call   80100348 <panic>
    panic("sched running");
801035f9:	83 ec 0c             	sub    $0xc,%esp
801035fc:	68 b9 6c 10 80       	push   $0x80106cb9
80103601:	e8 42 cd ff ff       	call   80100348 <panic>
    panic("sched interruptible");
80103606:	83 ec 0c             	sub    $0xc,%esp
80103609:	68 c7 6c 10 80       	push   $0x80106cc7
8010360e:	e8 35 cd ff ff       	call   80100348 <panic>

80103613 <exit>:
{
80103613:	55                   	push   %ebp
80103614:	89 e5                	mov    %esp,%ebp
80103616:	56                   	push   %esi
80103617:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103618:	e8 a5 fb ff ff       	call   801031c2 <myproc>
  if(curproc == initproc)
8010361d:	39 05 54 3e 11 80    	cmp    %eax,0x80113e54
80103623:	74 09                	je     8010362e <exit+0x1b>
80103625:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
80103627:	bb 00 00 00 00       	mov    $0x0,%ebx
8010362c:	eb 24                	jmp    80103652 <exit+0x3f>
    panic("init exiting");
8010362e:	83 ec 0c             	sub    $0xc,%esp
80103631:	68 db 6c 10 80       	push   $0x80106cdb
80103636:	e8 0d cd ff ff       	call   80100348 <panic>
      fileclose(curproc->ofile[fd]);
8010363b:	83 ec 0c             	sub    $0xc,%esp
8010363e:	50                   	push   %eax
8010363f:	e8 7f d6 ff ff       	call   80100cc3 <fileclose>
      curproc->ofile[fd] = 0;
80103644:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
8010364b:	00 
8010364c:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
8010364f:	83 c3 01             	add    $0x1,%ebx
80103652:	83 fb 0f             	cmp    $0xf,%ebx
80103655:	7f 0a                	jg     80103661 <exit+0x4e>
    if(curproc->ofile[fd]){
80103657:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
8010365b:	85 c0                	test   %eax,%eax
8010365d:	75 dc                	jne    8010363b <exit+0x28>
8010365f:	eb ee                	jmp    8010364f <exit+0x3c>
  begin_op();
80103661:	e8 18 f1 ff ff       	call   8010277e <begin_op>
  iput(curproc->cwd);
80103666:	83 ec 0c             	sub    $0xc,%esp
80103669:	ff 76 68             	push   0x68(%esi)
8010366c:	e8 05 e0 ff ff       	call   80101676 <iput>
  end_op();
80103671:	e8 82 f1 ff ff       	call   801027f8 <end_op>
  curproc->cwd = 0;
80103676:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010367d:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103684:	e8 38 06 00 00       	call   80103cc1 <acquire>
  wakeup1(curproc->parent);
80103689:	8b 46 14             	mov    0x14(%esi),%eax
8010368c:	e8 6b f9 ff ff       	call   80102ffc <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103691:	83 c4 10             	add    $0x10,%esp
80103694:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103699:	eb 06                	jmp    801036a1 <exit+0x8e>
8010369b:	81 c3 84 00 00 00    	add    $0x84,%ebx
801036a1:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
801036a7:	73 1a                	jae    801036c3 <exit+0xb0>
    if(p->parent == curproc){
801036a9:	39 73 14             	cmp    %esi,0x14(%ebx)
801036ac:	75 ed                	jne    8010369b <exit+0x88>
      p->parent = initproc;
801036ae:	a1 54 3e 11 80       	mov    0x80113e54,%eax
801036b3:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
801036b6:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801036ba:	75 df                	jne    8010369b <exit+0x88>
        wakeup1(initproc);
801036bc:	e8 3b f9 ff ff       	call   80102ffc <wakeup1>
801036c1:	eb d8                	jmp    8010369b <exit+0x88>
  curproc->state = ZOMBIE;
801036c3:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801036ca:	e8 a1 fe ff ff       	call   80103570 <sched>
  panic("zombie exit");
801036cf:	83 ec 0c             	sub    $0xc,%esp
801036d2:	68 e8 6c 10 80       	push   $0x80106ce8
801036d7:	e8 6c cc ff ff       	call   80100348 <panic>

801036dc <yield>:
{
801036dc:	55                   	push   %ebp
801036dd:	89 e5                	mov    %esp,%ebp
801036df:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801036e2:	68 20 1d 11 80       	push   $0x80111d20
801036e7:	e8 d5 05 00 00       	call   80103cc1 <acquire>
  myproc()->state = RUNNABLE;
801036ec:	e8 d1 fa ff ff       	call   801031c2 <myproc>
801036f1:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801036f8:	e8 73 fe ff ff       	call   80103570 <sched>
  release(&ptable.lock);
801036fd:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103704:	e8 1d 06 00 00       	call   80103d26 <release>
}
80103709:	83 c4 10             	add    $0x10,%esp
8010370c:	c9                   	leave  
8010370d:	c3                   	ret    

8010370e <sleep>:
{
8010370e:	55                   	push   %ebp
8010370f:	89 e5                	mov    %esp,%ebp
80103711:	56                   	push   %esi
80103712:	53                   	push   %ebx
80103713:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103716:	e8 a7 fa ff ff       	call   801031c2 <myproc>
  if(p == 0)
8010371b:	85 c0                	test   %eax,%eax
8010371d:	74 66                	je     80103785 <sleep+0x77>
8010371f:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
80103721:	85 f6                	test   %esi,%esi
80103723:	74 6d                	je     80103792 <sleep+0x84>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103725:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
8010372b:	74 18                	je     80103745 <sleep+0x37>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010372d:	83 ec 0c             	sub    $0xc,%esp
80103730:	68 20 1d 11 80       	push   $0x80111d20
80103735:	e8 87 05 00 00       	call   80103cc1 <acquire>
    release(lk);
8010373a:	89 34 24             	mov    %esi,(%esp)
8010373d:	e8 e4 05 00 00       	call   80103d26 <release>
80103742:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
80103745:	8b 45 08             	mov    0x8(%ebp),%eax
80103748:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
8010374b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103752:	e8 19 fe ff ff       	call   80103570 <sched>
  p->chan = 0;
80103757:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
8010375e:	81 fe 20 1d 11 80    	cmp    $0x80111d20,%esi
80103764:	74 18                	je     8010377e <sleep+0x70>
    release(&ptable.lock);
80103766:	83 ec 0c             	sub    $0xc,%esp
80103769:	68 20 1d 11 80       	push   $0x80111d20
8010376e:	e8 b3 05 00 00       	call   80103d26 <release>
    acquire(lk);
80103773:	89 34 24             	mov    %esi,(%esp)
80103776:	e8 46 05 00 00       	call   80103cc1 <acquire>
8010377b:	83 c4 10             	add    $0x10,%esp
}
8010377e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103781:	5b                   	pop    %ebx
80103782:	5e                   	pop    %esi
80103783:	5d                   	pop    %ebp
80103784:	c3                   	ret    
    panic("sleep");
80103785:	83 ec 0c             	sub    $0xc,%esp
80103788:	68 f4 6c 10 80       	push   $0x80106cf4
8010378d:	e8 b6 cb ff ff       	call   80100348 <panic>
    panic("sleep without lk");
80103792:	83 ec 0c             	sub    $0xc,%esp
80103795:	68 fa 6c 10 80       	push   $0x80106cfa
8010379a:	e8 a9 cb ff ff       	call   80100348 <panic>

8010379f <wait>:
{
8010379f:	55                   	push   %ebp
801037a0:	89 e5                	mov    %esp,%ebp
801037a2:	56                   	push   %esi
801037a3:	53                   	push   %ebx
  struct proc *curproc = myproc();
801037a4:	e8 19 fa ff ff       	call   801031c2 <myproc>
801037a9:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
801037ab:	83 ec 0c             	sub    $0xc,%esp
801037ae:	68 20 1d 11 80       	push   $0x80111d20
801037b3:	e8 09 05 00 00       	call   80103cc1 <acquire>
801037b8:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801037bb:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037c0:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
801037c5:	eb 5e                	jmp    80103825 <wait+0x86>
        pid = p->pid;
801037c7:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801037ca:	83 ec 0c             	sub    $0xc,%esp
801037cd:	ff 73 08             	push   0x8(%ebx)
801037d0:	e8 b7 e7 ff ff       	call   80101f8c <kfree>
        p->kstack = 0;
801037d5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801037dc:	83 c4 04             	add    $0x4,%esp
801037df:	ff 73 04             	push   0x4(%ebx)
801037e2:	e8 7c 2c 00 00       	call   80106463 <freevm>
        p->pid = 0;
801037e7:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801037ee:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801037f5:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801037f9:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103800:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103807:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
8010380e:	e8 13 05 00 00       	call   80103d26 <release>
        return pid;
80103813:	83 c4 10             	add    $0x10,%esp
}
80103816:	89 f0                	mov    %esi,%eax
80103818:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010381b:	5b                   	pop    %ebx
8010381c:	5e                   	pop    %esi
8010381d:	5d                   	pop    %ebp
8010381e:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010381f:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103825:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
8010382b:	73 12                	jae    8010383f <wait+0xa0>
      if(p->parent != curproc)
8010382d:	39 73 14             	cmp    %esi,0x14(%ebx)
80103830:	75 ed                	jne    8010381f <wait+0x80>
      if(p->state == ZOMBIE){
80103832:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103836:	74 8f                	je     801037c7 <wait+0x28>
      havekids = 1;
80103838:	b8 01 00 00 00       	mov    $0x1,%eax
8010383d:	eb e0                	jmp    8010381f <wait+0x80>
    if(!havekids || curproc->killed){
8010383f:	85 c0                	test   %eax,%eax
80103841:	74 06                	je     80103849 <wait+0xaa>
80103843:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
80103847:	74 17                	je     80103860 <wait+0xc1>
      release(&ptable.lock);
80103849:	83 ec 0c             	sub    $0xc,%esp
8010384c:	68 20 1d 11 80       	push   $0x80111d20
80103851:	e8 d0 04 00 00       	call   80103d26 <release>
      return -1;
80103856:	83 c4 10             	add    $0x10,%esp
80103859:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010385e:	eb b6                	jmp    80103816 <wait+0x77>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103860:	83 ec 08             	sub    $0x8,%esp
80103863:	68 20 1d 11 80       	push   $0x80111d20
80103868:	56                   	push   %esi
80103869:	e8 a0 fe ff ff       	call   8010370e <sleep>
    havekids = 0;
8010386e:	83 c4 10             	add    $0x10,%esp
80103871:	e9 45 ff ff ff       	jmp    801037bb <wait+0x1c>

80103876 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103876:	55                   	push   %ebp
80103877:	89 e5                	mov    %esp,%ebp
80103879:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010387c:	68 20 1d 11 80       	push   $0x80111d20
80103881:	e8 3b 04 00 00       	call   80103cc1 <acquire>
  wakeup1(chan);
80103886:	8b 45 08             	mov    0x8(%ebp),%eax
80103889:	e8 6e f7 ff ff       	call   80102ffc <wakeup1>
  release(&ptable.lock);
8010388e:	c7 04 24 20 1d 11 80 	movl   $0x80111d20,(%esp)
80103895:	e8 8c 04 00 00       	call   80103d26 <release>
}
8010389a:	83 c4 10             	add    $0x10,%esp
8010389d:	c9                   	leave  
8010389e:	c3                   	ret    

8010389f <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
8010389f:	55                   	push   %ebp
801038a0:	89 e5                	mov    %esp,%ebp
801038a2:	53                   	push   %ebx
801038a3:	83 ec 10             	sub    $0x10,%esp
801038a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801038a9:	68 20 1d 11 80       	push   $0x80111d20
801038ae:	e8 0e 04 00 00       	call   80103cc1 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038b3:	83 c4 10             	add    $0x10,%esp
801038b6:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
801038bb:	eb 0e                	jmp    801038cb <kill+0x2c>
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801038bd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801038c4:	eb 1e                	jmp    801038e4 <kill+0x45>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038c6:	05 84 00 00 00       	add    $0x84,%eax
801038cb:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
801038d0:	73 2c                	jae    801038fe <kill+0x5f>
    if(p->pid == pid){
801038d2:	39 58 10             	cmp    %ebx,0x10(%eax)
801038d5:	75 ef                	jne    801038c6 <kill+0x27>
      p->killed = 1;
801038d7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801038de:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801038e2:	74 d9                	je     801038bd <kill+0x1e>
      release(&ptable.lock);
801038e4:	83 ec 0c             	sub    $0xc,%esp
801038e7:	68 20 1d 11 80       	push   $0x80111d20
801038ec:	e8 35 04 00 00       	call   80103d26 <release>
      return 0;
801038f1:	83 c4 10             	add    $0x10,%esp
801038f4:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801038f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038fc:	c9                   	leave  
801038fd:	c3                   	ret    
  release(&ptable.lock);
801038fe:	83 ec 0c             	sub    $0xc,%esp
80103901:	68 20 1d 11 80       	push   $0x80111d20
80103906:	e8 1b 04 00 00       	call   80103d26 <release>
  return -1;
8010390b:	83 c4 10             	add    $0x10,%esp
8010390e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103913:	eb e4                	jmp    801038f9 <kill+0x5a>

80103915 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103915:	55                   	push   %ebp
80103916:	89 e5                	mov    %esp,%ebp
80103918:	56                   	push   %esi
80103919:	53                   	push   %ebx
8010391a:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010391d:	bb 54 1d 11 80       	mov    $0x80111d54,%ebx
80103922:	eb 36                	jmp    8010395a <procdump+0x45>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
80103924:	b8 0b 6d 10 80       	mov    $0x80106d0b,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80103929:	8d 53 6c             	lea    0x6c(%ebx),%edx
8010392c:	52                   	push   %edx
8010392d:	50                   	push   %eax
8010392e:	ff 73 10             	push   0x10(%ebx)
80103931:	68 0f 6d 10 80       	push   $0x80106d0f
80103936:	e8 cc cc ff ff       	call   80100607 <cprintf>
    if(p->state == SLEEPING){
8010393b:	83 c4 10             	add    $0x10,%esp
8010393e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103942:	74 3c                	je     80103980 <procdump+0x6b>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103944:	83 ec 0c             	sub    $0xc,%esp
80103947:	68 87 70 10 80       	push   $0x80107087
8010394c:	e8 b6 cc ff ff       	call   80100607 <cprintf>
80103951:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103954:	81 c3 84 00 00 00    	add    $0x84,%ebx
8010395a:	81 fb 54 3e 11 80    	cmp    $0x80113e54,%ebx
80103960:	73 61                	jae    801039c3 <procdump+0xae>
    if(p->state == UNUSED)
80103962:	8b 43 0c             	mov    0xc(%ebx),%eax
80103965:	85 c0                	test   %eax,%eax
80103967:	74 eb                	je     80103954 <procdump+0x3f>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103969:	83 f8 05             	cmp    $0x5,%eax
8010396c:	77 b6                	ja     80103924 <procdump+0xf>
8010396e:	8b 04 85 6c 6d 10 80 	mov    -0x7fef9294(,%eax,4),%eax
80103975:	85 c0                	test   %eax,%eax
80103977:	75 b0                	jne    80103929 <procdump+0x14>
      state = "???";
80103979:	b8 0b 6d 10 80       	mov    $0x80106d0b,%eax
8010397e:	eb a9                	jmp    80103929 <procdump+0x14>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103980:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103983:	8b 40 0c             	mov    0xc(%eax),%eax
80103986:	83 c0 08             	add    $0x8,%eax
80103989:	83 ec 08             	sub    $0x8,%esp
8010398c:	8d 55 d0             	lea    -0x30(%ebp),%edx
8010398f:	52                   	push   %edx
80103990:	50                   	push   %eax
80103991:	e8 0a 02 00 00       	call   80103ba0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103996:	83 c4 10             	add    $0x10,%esp
80103999:	be 00 00 00 00       	mov    $0x0,%esi
8010399e:	eb 14                	jmp    801039b4 <procdump+0x9f>
        cprintf(" %p", pc[i]);
801039a0:	83 ec 08             	sub    $0x8,%esp
801039a3:	50                   	push   %eax
801039a4:	68 61 67 10 80       	push   $0x80106761
801039a9:	e8 59 cc ff ff       	call   80100607 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801039ae:	83 c6 01             	add    $0x1,%esi
801039b1:	83 c4 10             	add    $0x10,%esp
801039b4:	83 fe 09             	cmp    $0x9,%esi
801039b7:	7f 8b                	jg     80103944 <procdump+0x2f>
801039b9:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
801039bd:	85 c0                	test   %eax,%eax
801039bf:	75 df                	jne    801039a0 <procdump+0x8b>
801039c1:	eb 81                	jmp    80103944 <procdump+0x2f>
  }
}
801039c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039c6:	5b                   	pop    %ebx
801039c7:	5e                   	pop    %esi
801039c8:	5d                   	pop    %ebp
801039c9:	c3                   	ret    

801039ca <settickets>:

int
settickets(int number)
{
801039ca:	55                   	push   %ebp
801039cb:	89 e5                	mov    %esp,%ebp
801039cd:	53                   	push   %ebx
801039ce:	83 ec 04             	sub    $0x4,%esp
801039d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(number > 1 || number < 0)
801039d4:	83 fb 01             	cmp    $0x1,%ebx
801039d7:	77 12                	ja     801039eb <settickets+0x21>
    return -1;

  myproc()->tickets = number;
801039d9:	e8 e4 f7 ff ff       	call   801031c2 <myproc>
801039de:	89 58 7c             	mov    %ebx,0x7c(%eax)

  return 0;
801039e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801039e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039e9:	c9                   	leave  
801039ea:	c3                   	ret    
    return -1;
801039eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039f0:	eb f4                	jmp    801039e6 <settickets+0x1c>

801039f2 <getpinfo>:

int
getpinfo(struct pstat* pstat)
{
801039f2:	55                   	push   %ebp
801039f3:	89 e5                	mov    %esp,%ebp
801039f5:	53                   	push   %ebx
801039f6:	83 ec 04             	sub    $0x4,%esp
801039f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!pstat)
801039fc:	85 db                	test   %ebx,%ebx
801039fe:	74 73                	je     80103a73 <getpinfo+0x81>
    return -1;

  struct proc *p;
  int i = 0;

  acquire(&ptable.lock);
80103a00:	83 ec 0c             	sub    $0xc,%esp
80103a03:	68 20 1d 11 80       	push   $0x80111d20
80103a08:	e8 b4 02 00 00       	call   80103cc1 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a0d:	83 c4 10             	add    $0x10,%esp
  int i = 0;
80103a10:	ba 00 00 00 00       	mov    $0x0,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a15:	b8 54 1d 11 80       	mov    $0x80111d54,%eax
80103a1a:	eb 36                	jmp    80103a52 <getpinfo+0x60>
    pstat->inuse[i] = p->state == UNUSED ? 1 : 0;
80103a1c:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
80103a20:	0f 94 c1             	sete   %cl
80103a23:	0f b6 c9             	movzbl %cl,%ecx
80103a26:	89 0c 93             	mov    %ecx,(%ebx,%edx,4)
    pstat->tickets[i] = p->tickets;
80103a29:	8b 48 7c             	mov    0x7c(%eax),%ecx
80103a2c:	89 8c 93 00 01 00 00 	mov    %ecx,0x100(%ebx,%edx,4)
    pstat->pid[i] = p->pid;
80103a33:	8b 48 10             	mov    0x10(%eax),%ecx
80103a36:	89 8c 93 00 02 00 00 	mov    %ecx,0x200(%ebx,%edx,4)
    pstat->ticks[i] = p->ticks;
80103a3d:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80103a43:	89 8c 93 00 03 00 00 	mov    %ecx,0x300(%ebx,%edx,4)
    i++;
80103a4a:	83 c2 01             	add    $0x1,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a4d:	05 84 00 00 00       	add    $0x84,%eax
80103a52:	3d 54 3e 11 80       	cmp    $0x80113e54,%eax
80103a57:	72 c3                	jb     80103a1c <getpinfo+0x2a>
  }
  release(&ptable.lock);
80103a59:	83 ec 0c             	sub    $0xc,%esp
80103a5c:	68 20 1d 11 80       	push   $0x80111d20
80103a61:	e8 c0 02 00 00       	call   80103d26 <release>

  return 0;
80103a66:	83 c4 10             	add    $0x10,%esp
80103a69:	b8 00 00 00 00       	mov    $0x0,%eax
80103a6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a71:	c9                   	leave  
80103a72:	c3                   	ret    
    return -1;
80103a73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a78:	eb f4                	jmp    80103a6e <getpinfo+0x7c>

80103a7a <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103a7a:	55                   	push   %ebp
80103a7b:	89 e5                	mov    %esp,%ebp
80103a7d:	53                   	push   %ebx
80103a7e:	83 ec 0c             	sub    $0xc,%esp
80103a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103a84:	68 84 6d 10 80       	push   $0x80106d84
80103a89:	8d 43 04             	lea    0x4(%ebx),%eax
80103a8c:	50                   	push   %eax
80103a8d:	e8 f3 00 00 00       	call   80103b85 <initlock>
  lk->name = name;
80103a92:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a95:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103a98:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103a9e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103aa5:	83 c4 10             	add    $0x10,%esp
80103aa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aab:	c9                   	leave  
80103aac:	c3                   	ret    

80103aad <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103aad:	55                   	push   %ebp
80103aae:	89 e5                	mov    %esp,%ebp
80103ab0:	56                   	push   %esi
80103ab1:	53                   	push   %ebx
80103ab2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103ab5:	8d 73 04             	lea    0x4(%ebx),%esi
80103ab8:	83 ec 0c             	sub    $0xc,%esp
80103abb:	56                   	push   %esi
80103abc:	e8 00 02 00 00       	call   80103cc1 <acquire>
  while (lk->locked) {
80103ac1:	83 c4 10             	add    $0x10,%esp
80103ac4:	eb 0d                	jmp    80103ad3 <acquiresleep+0x26>
    sleep(lk, &lk->lk);
80103ac6:	83 ec 08             	sub    $0x8,%esp
80103ac9:	56                   	push   %esi
80103aca:	53                   	push   %ebx
80103acb:	e8 3e fc ff ff       	call   8010370e <sleep>
80103ad0:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80103ad3:	83 3b 00             	cmpl   $0x0,(%ebx)
80103ad6:	75 ee                	jne    80103ac6 <acquiresleep+0x19>
  }
  lk->locked = 1;
80103ad8:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103ade:	e8 df f6 ff ff       	call   801031c2 <myproc>
80103ae3:	8b 40 10             	mov    0x10(%eax),%eax
80103ae6:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103ae9:	83 ec 0c             	sub    $0xc,%esp
80103aec:	56                   	push   %esi
80103aed:	e8 34 02 00 00       	call   80103d26 <release>
}
80103af2:	83 c4 10             	add    $0x10,%esp
80103af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103af8:	5b                   	pop    %ebx
80103af9:	5e                   	pop    %esi
80103afa:	5d                   	pop    %ebp
80103afb:	c3                   	ret    

80103afc <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103afc:	55                   	push   %ebp
80103afd:	89 e5                	mov    %esp,%ebp
80103aff:	56                   	push   %esi
80103b00:	53                   	push   %ebx
80103b01:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b04:	8d 73 04             	lea    0x4(%ebx),%esi
80103b07:	83 ec 0c             	sub    $0xc,%esp
80103b0a:	56                   	push   %esi
80103b0b:	e8 b1 01 00 00       	call   80103cc1 <acquire>
  lk->locked = 0;
80103b10:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b16:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103b1d:	89 1c 24             	mov    %ebx,(%esp)
80103b20:	e8 51 fd ff ff       	call   80103876 <wakeup>
  release(&lk->lk);
80103b25:	89 34 24             	mov    %esi,(%esp)
80103b28:	e8 f9 01 00 00       	call   80103d26 <release>
}
80103b2d:	83 c4 10             	add    $0x10,%esp
80103b30:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b33:	5b                   	pop    %ebx
80103b34:	5e                   	pop    %esi
80103b35:	5d                   	pop    %ebp
80103b36:	c3                   	ret    

80103b37 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103b37:	55                   	push   %ebp
80103b38:	89 e5                	mov    %esp,%ebp
80103b3a:	56                   	push   %esi
80103b3b:	53                   	push   %ebx
80103b3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103b3f:	8d 73 04             	lea    0x4(%ebx),%esi
80103b42:	83 ec 0c             	sub    $0xc,%esp
80103b45:	56                   	push   %esi
80103b46:	e8 76 01 00 00       	call   80103cc1 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103b4b:	83 c4 10             	add    $0x10,%esp
80103b4e:	83 3b 00             	cmpl   $0x0,(%ebx)
80103b51:	75 17                	jne    80103b6a <holdingsleep+0x33>
80103b53:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103b58:	83 ec 0c             	sub    $0xc,%esp
80103b5b:	56                   	push   %esi
80103b5c:	e8 c5 01 00 00       	call   80103d26 <release>
  return r;
}
80103b61:	89 d8                	mov    %ebx,%eax
80103b63:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b66:	5b                   	pop    %ebx
80103b67:	5e                   	pop    %esi
80103b68:	5d                   	pop    %ebp
80103b69:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103b6a:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103b6d:	e8 50 f6 ff ff       	call   801031c2 <myproc>
80103b72:	3b 58 10             	cmp    0x10(%eax),%ebx
80103b75:	74 07                	je     80103b7e <holdingsleep+0x47>
80103b77:	bb 00 00 00 00       	mov    $0x0,%ebx
80103b7c:	eb da                	jmp    80103b58 <holdingsleep+0x21>
80103b7e:	bb 01 00 00 00       	mov    $0x1,%ebx
80103b83:	eb d3                	jmp    80103b58 <holdingsleep+0x21>

80103b85 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103b85:	55                   	push   %ebp
80103b86:	89 e5                	mov    %esp,%ebp
80103b88:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b8e:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103b91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103b97:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103b9e:	5d                   	pop    %ebp
80103b9f:	c3                   	ret    

80103ba0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	53                   	push   %ebx
80103ba4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103ba7:	8b 45 08             	mov    0x8(%ebp),%eax
80103baa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103bad:	b8 00 00 00 00       	mov    $0x0,%eax
80103bb2:	83 f8 09             	cmp    $0x9,%eax
80103bb5:	7f 25                	jg     80103bdc <getcallerpcs+0x3c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103bb7:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103bbd:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103bc3:	77 17                	ja     80103bdc <getcallerpcs+0x3c>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103bc5:	8b 5a 04             	mov    0x4(%edx),%ebx
80103bc8:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103bcb:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103bcd:	83 c0 01             	add    $0x1,%eax
80103bd0:	eb e0                	jmp    80103bb2 <getcallerpcs+0x12>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103bd2:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103bd9:	83 c0 01             	add    $0x1,%eax
80103bdc:	83 f8 09             	cmp    $0x9,%eax
80103bdf:	7e f1                	jle    80103bd2 <getcallerpcs+0x32>
}
80103be1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103be4:	c9                   	leave  
80103be5:	c3                   	ret    

80103be6 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103be6:	55                   	push   %ebp
80103be7:	89 e5                	mov    %esp,%ebp
80103be9:	53                   	push   %ebx
80103bea:	83 ec 04             	sub    $0x4,%esp
80103bed:	9c                   	pushf  
80103bee:	5b                   	pop    %ebx
  asm volatile("cli");
80103bef:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103bf0:	e8 56 f5 ff ff       	call   8010314b <mycpu>
80103bf5:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103bfc:	74 11                	je     80103c0f <pushcli+0x29>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103bfe:	e8 48 f5 ff ff       	call   8010314b <mycpu>
80103c03:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80103c0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c0d:	c9                   	leave  
80103c0e:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103c0f:	e8 37 f5 ff ff       	call   8010314b <mycpu>
80103c14:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103c1a:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103c20:	eb dc                	jmp    80103bfe <pushcli+0x18>

80103c22 <popcli>:

void
popcli(void)
{
80103c22:	55                   	push   %ebp
80103c23:	89 e5                	mov    %esp,%ebp
80103c25:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c28:	9c                   	pushf  
80103c29:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c2a:	f6 c4 02             	test   $0x2,%ah
80103c2d:	75 28                	jne    80103c57 <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103c2f:	e8 17 f5 ff ff       	call   8010314b <mycpu>
80103c34:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103c3a:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103c3d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103c43:	85 d2                	test   %edx,%edx
80103c45:	78 1d                	js     80103c64 <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103c47:	e8 ff f4 ff ff       	call   8010314b <mycpu>
80103c4c:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103c53:	74 1c                	je     80103c71 <popcli+0x4f>
    sti();
}
80103c55:	c9                   	leave  
80103c56:	c3                   	ret    
    panic("popcli - interruptible");
80103c57:	83 ec 0c             	sub    $0xc,%esp
80103c5a:	68 8f 6d 10 80       	push   $0x80106d8f
80103c5f:	e8 e4 c6 ff ff       	call   80100348 <panic>
    panic("popcli");
80103c64:	83 ec 0c             	sub    $0xc,%esp
80103c67:	68 a6 6d 10 80       	push   $0x80106da6
80103c6c:	e8 d7 c6 ff ff       	call   80100348 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103c71:	e8 d5 f4 ff ff       	call   8010314b <mycpu>
80103c76:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103c7d:	74 d6                	je     80103c55 <popcli+0x33>
  asm volatile("sti");
80103c7f:	fb                   	sti    
}
80103c80:	eb d3                	jmp    80103c55 <popcli+0x33>

80103c82 <holding>:
{
80103c82:	55                   	push   %ebp
80103c83:	89 e5                	mov    %esp,%ebp
80103c85:	53                   	push   %ebx
80103c86:	83 ec 04             	sub    $0x4,%esp
80103c89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103c8c:	e8 55 ff ff ff       	call   80103be6 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103c91:	83 3b 00             	cmpl   $0x0,(%ebx)
80103c94:	75 11                	jne    80103ca7 <holding+0x25>
80103c96:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103c9b:	e8 82 ff ff ff       	call   80103c22 <popcli>
}
80103ca0:	89 d8                	mov    %ebx,%eax
80103ca2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ca5:	c9                   	leave  
80103ca6:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103ca7:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103caa:	e8 9c f4 ff ff       	call   8010314b <mycpu>
80103caf:	39 c3                	cmp    %eax,%ebx
80103cb1:	74 07                	je     80103cba <holding+0x38>
80103cb3:	bb 00 00 00 00       	mov    $0x0,%ebx
80103cb8:	eb e1                	jmp    80103c9b <holding+0x19>
80103cba:	bb 01 00 00 00       	mov    $0x1,%ebx
80103cbf:	eb da                	jmp    80103c9b <holding+0x19>

80103cc1 <acquire>:
{
80103cc1:	55                   	push   %ebp
80103cc2:	89 e5                	mov    %esp,%ebp
80103cc4:	53                   	push   %ebx
80103cc5:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103cc8:	e8 19 ff ff ff       	call   80103be6 <pushcli>
  if(holding(lk))
80103ccd:	83 ec 0c             	sub    $0xc,%esp
80103cd0:	ff 75 08             	push   0x8(%ebp)
80103cd3:	e8 aa ff ff ff       	call   80103c82 <holding>
80103cd8:	83 c4 10             	add    $0x10,%esp
80103cdb:	85 c0                	test   %eax,%eax
80103cdd:	75 3a                	jne    80103d19 <acquire+0x58>
  while(xchg(&lk->locked, 1) != 0)
80103cdf:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103ce2:	b8 01 00 00 00       	mov    $0x1,%eax
80103ce7:	f0 87 02             	lock xchg %eax,(%edx)
80103cea:	85 c0                	test   %eax,%eax
80103cec:	75 f1                	jne    80103cdf <acquire+0x1e>
  __sync_synchronize();
80103cee:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103cf3:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103cf6:	e8 50 f4 ff ff       	call   8010314b <mycpu>
80103cfb:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103cfe:	8b 45 08             	mov    0x8(%ebp),%eax
80103d01:	83 c0 0c             	add    $0xc,%eax
80103d04:	83 ec 08             	sub    $0x8,%esp
80103d07:	50                   	push   %eax
80103d08:	8d 45 08             	lea    0x8(%ebp),%eax
80103d0b:	50                   	push   %eax
80103d0c:	e8 8f fe ff ff       	call   80103ba0 <getcallerpcs>
}
80103d11:	83 c4 10             	add    $0x10,%esp
80103d14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d17:	c9                   	leave  
80103d18:	c3                   	ret    
    panic("acquire");
80103d19:	83 ec 0c             	sub    $0xc,%esp
80103d1c:	68 ad 6d 10 80       	push   $0x80106dad
80103d21:	e8 22 c6 ff ff       	call   80100348 <panic>

80103d26 <release>:
{
80103d26:	55                   	push   %ebp
80103d27:	89 e5                	mov    %esp,%ebp
80103d29:	53                   	push   %ebx
80103d2a:	83 ec 10             	sub    $0x10,%esp
80103d2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103d30:	53                   	push   %ebx
80103d31:	e8 4c ff ff ff       	call   80103c82 <holding>
80103d36:	83 c4 10             	add    $0x10,%esp
80103d39:	85 c0                	test   %eax,%eax
80103d3b:	74 23                	je     80103d60 <release+0x3a>
  lk->pcs[0] = 0;
80103d3d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103d44:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103d4b:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103d50:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103d56:	e8 c7 fe ff ff       	call   80103c22 <popcli>
}
80103d5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d5e:	c9                   	leave  
80103d5f:	c3                   	ret    
    panic("release");
80103d60:	83 ec 0c             	sub    $0xc,%esp
80103d63:	68 b5 6d 10 80       	push   $0x80106db5
80103d68:	e8 db c5 ff ff       	call   80100348 <panic>

80103d6d <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103d6d:	55                   	push   %ebp
80103d6e:	89 e5                	mov    %esp,%ebp
80103d70:	57                   	push   %edi
80103d71:	53                   	push   %ebx
80103d72:	8b 55 08             	mov    0x8(%ebp),%edx
80103d75:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80103d7b:	f6 c2 03             	test   $0x3,%dl
80103d7e:	75 25                	jne    80103da5 <memset+0x38>
80103d80:	f6 c1 03             	test   $0x3,%cl
80103d83:	75 20                	jne    80103da5 <memset+0x38>
    c &= 0xFF;
80103d85:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103d88:	c1 e9 02             	shr    $0x2,%ecx
80103d8b:	c1 e0 18             	shl    $0x18,%eax
80103d8e:	89 fb                	mov    %edi,%ebx
80103d90:	c1 e3 10             	shl    $0x10,%ebx
80103d93:	09 d8                	or     %ebx,%eax
80103d95:	89 fb                	mov    %edi,%ebx
80103d97:	c1 e3 08             	shl    $0x8,%ebx
80103d9a:	09 d8                	or     %ebx,%eax
80103d9c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103d9e:	89 d7                	mov    %edx,%edi
80103da0:	fc                   	cld    
80103da1:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103da3:	eb 05                	jmp    80103daa <memset+0x3d>
  asm volatile("cld; rep stosb" :
80103da5:	89 d7                	mov    %edx,%edi
80103da7:	fc                   	cld    
80103da8:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80103daa:	89 d0                	mov    %edx,%eax
80103dac:	5b                   	pop    %ebx
80103dad:	5f                   	pop    %edi
80103dae:	5d                   	pop    %ebp
80103daf:	c3                   	ret    

80103db0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	56                   	push   %esi
80103db4:	53                   	push   %ebx
80103db5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103db8:	8b 55 0c             	mov    0xc(%ebp),%edx
80103dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103dbe:	eb 08                	jmp    80103dc8 <memcmp+0x18>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80103dc0:	83 c1 01             	add    $0x1,%ecx
80103dc3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80103dc6:	89 f0                	mov    %esi,%eax
80103dc8:	8d 70 ff             	lea    -0x1(%eax),%esi
80103dcb:	85 c0                	test   %eax,%eax
80103dcd:	74 12                	je     80103de1 <memcmp+0x31>
    if(*s1 != *s2)
80103dcf:	0f b6 01             	movzbl (%ecx),%eax
80103dd2:	0f b6 1a             	movzbl (%edx),%ebx
80103dd5:	38 d8                	cmp    %bl,%al
80103dd7:	74 e7                	je     80103dc0 <memcmp+0x10>
      return *s1 - *s2;
80103dd9:	0f b6 c0             	movzbl %al,%eax
80103ddc:	0f b6 db             	movzbl %bl,%ebx
80103ddf:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80103de1:	5b                   	pop    %ebx
80103de2:	5e                   	pop    %esi
80103de3:	5d                   	pop    %ebp
80103de4:	c3                   	ret    

80103de5 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103de5:	55                   	push   %ebp
80103de6:	89 e5                	mov    %esp,%ebp
80103de8:	56                   	push   %esi
80103de9:	53                   	push   %ebx
80103dea:	8b 75 08             	mov    0x8(%ebp),%esi
80103ded:	8b 55 0c             	mov    0xc(%ebp),%edx
80103df0:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103df3:	39 f2                	cmp    %esi,%edx
80103df5:	73 3c                	jae    80103e33 <memmove+0x4e>
80103df7:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103dfa:	39 f1                	cmp    %esi,%ecx
80103dfc:	76 39                	jbe    80103e37 <memmove+0x52>
    s += n;
    d += n;
80103dfe:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
80103e01:	eb 0d                	jmp    80103e10 <memmove+0x2b>
      *--d = *--s;
80103e03:	83 e9 01             	sub    $0x1,%ecx
80103e06:	83 ea 01             	sub    $0x1,%edx
80103e09:	0f b6 01             	movzbl (%ecx),%eax
80103e0c:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
80103e0e:	89 d8                	mov    %ebx,%eax
80103e10:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103e13:	85 c0                	test   %eax,%eax
80103e15:	75 ec                	jne    80103e03 <memmove+0x1e>
80103e17:	eb 14                	jmp    80103e2d <memmove+0x48>
  } else
    while(n-- > 0)
      *d++ = *s++;
80103e19:	0f b6 02             	movzbl (%edx),%eax
80103e1c:	88 01                	mov    %al,(%ecx)
80103e1e:	8d 49 01             	lea    0x1(%ecx),%ecx
80103e21:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
80103e24:	89 d8                	mov    %ebx,%eax
80103e26:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103e29:	85 c0                	test   %eax,%eax
80103e2b:	75 ec                	jne    80103e19 <memmove+0x34>

  return dst;
}
80103e2d:	89 f0                	mov    %esi,%eax
80103e2f:	5b                   	pop    %ebx
80103e30:	5e                   	pop    %esi
80103e31:	5d                   	pop    %ebp
80103e32:	c3                   	ret    
80103e33:	89 f1                	mov    %esi,%ecx
80103e35:	eb ef                	jmp    80103e26 <memmove+0x41>
80103e37:	89 f1                	mov    %esi,%ecx
80103e39:	eb eb                	jmp    80103e26 <memmove+0x41>

80103e3b <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103e3b:	55                   	push   %ebp
80103e3c:	89 e5                	mov    %esp,%ebp
80103e3e:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80103e41:	ff 75 10             	push   0x10(%ebp)
80103e44:	ff 75 0c             	push   0xc(%ebp)
80103e47:	ff 75 08             	push   0x8(%ebp)
80103e4a:	e8 96 ff ff ff       	call   80103de5 <memmove>
}
80103e4f:	c9                   	leave  
80103e50:	c3                   	ret    

80103e51 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103e51:	55                   	push   %ebp
80103e52:	89 e5                	mov    %esp,%ebp
80103e54:	53                   	push   %ebx
80103e55:	8b 55 08             	mov    0x8(%ebp),%edx
80103e58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103e5b:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80103e5e:	eb 09                	jmp    80103e69 <strncmp+0x18>
    n--, p++, q++;
80103e60:	83 e8 01             	sub    $0x1,%eax
80103e63:	83 c2 01             	add    $0x1,%edx
80103e66:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80103e69:	85 c0                	test   %eax,%eax
80103e6b:	74 0b                	je     80103e78 <strncmp+0x27>
80103e6d:	0f b6 1a             	movzbl (%edx),%ebx
80103e70:	84 db                	test   %bl,%bl
80103e72:	74 04                	je     80103e78 <strncmp+0x27>
80103e74:	3a 19                	cmp    (%ecx),%bl
80103e76:	74 e8                	je     80103e60 <strncmp+0xf>
  if(n == 0)
80103e78:	85 c0                	test   %eax,%eax
80103e7a:	74 0d                	je     80103e89 <strncmp+0x38>
    return 0;
  return (uchar)*p - (uchar)*q;
80103e7c:	0f b6 02             	movzbl (%edx),%eax
80103e7f:	0f b6 11             	movzbl (%ecx),%edx
80103e82:	29 d0                	sub    %edx,%eax
}
80103e84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e87:	c9                   	leave  
80103e88:	c3                   	ret    
    return 0;
80103e89:	b8 00 00 00 00       	mov    $0x0,%eax
80103e8e:	eb f4                	jmp    80103e84 <strncmp+0x33>

80103e90 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	57                   	push   %edi
80103e94:	56                   	push   %esi
80103e95:	53                   	push   %ebx
80103e96:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103e9c:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103e9f:	89 fa                	mov    %edi,%edx
80103ea1:	eb 04                	jmp    80103ea7 <strncpy+0x17>
80103ea3:	89 f1                	mov    %esi,%ecx
80103ea5:	89 da                	mov    %ebx,%edx
80103ea7:	89 c3                	mov    %eax,%ebx
80103ea9:	83 e8 01             	sub    $0x1,%eax
80103eac:	85 db                	test   %ebx,%ebx
80103eae:	7e 11                	jle    80103ec1 <strncpy+0x31>
80103eb0:	8d 71 01             	lea    0x1(%ecx),%esi
80103eb3:	8d 5a 01             	lea    0x1(%edx),%ebx
80103eb6:	0f b6 09             	movzbl (%ecx),%ecx
80103eb9:	88 0a                	mov    %cl,(%edx)
80103ebb:	84 c9                	test   %cl,%cl
80103ebd:	75 e4                	jne    80103ea3 <strncpy+0x13>
80103ebf:	89 da                	mov    %ebx,%edx
    ;
  while(n-- > 0)
80103ec1:	8d 48 ff             	lea    -0x1(%eax),%ecx
80103ec4:	85 c0                	test   %eax,%eax
80103ec6:	7e 0a                	jle    80103ed2 <strncpy+0x42>
    *s++ = 0;
80103ec8:	c6 02 00             	movb   $0x0,(%edx)
  while(n-- > 0)
80103ecb:	89 c8                	mov    %ecx,%eax
    *s++ = 0;
80103ecd:	8d 52 01             	lea    0x1(%edx),%edx
80103ed0:	eb ef                	jmp    80103ec1 <strncpy+0x31>
  return os;
}
80103ed2:	89 f8                	mov    %edi,%eax
80103ed4:	5b                   	pop    %ebx
80103ed5:	5e                   	pop    %esi
80103ed6:	5f                   	pop    %edi
80103ed7:	5d                   	pop    %ebp
80103ed8:	c3                   	ret    

80103ed9 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103ed9:	55                   	push   %ebp
80103eda:	89 e5                	mov    %esp,%ebp
80103edc:	57                   	push   %edi
80103edd:	56                   	push   %esi
80103ede:	53                   	push   %ebx
80103edf:	8b 7d 08             	mov    0x8(%ebp),%edi
80103ee2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103ee5:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80103ee8:	85 c0                	test   %eax,%eax
80103eea:	7e 23                	jle    80103f0f <safestrcpy+0x36>
80103eec:	89 fa                	mov    %edi,%edx
80103eee:	eb 04                	jmp    80103ef4 <safestrcpy+0x1b>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103ef0:	89 f1                	mov    %esi,%ecx
80103ef2:	89 da                	mov    %ebx,%edx
80103ef4:	83 e8 01             	sub    $0x1,%eax
80103ef7:	85 c0                	test   %eax,%eax
80103ef9:	7e 11                	jle    80103f0c <safestrcpy+0x33>
80103efb:	8d 71 01             	lea    0x1(%ecx),%esi
80103efe:	8d 5a 01             	lea    0x1(%edx),%ebx
80103f01:	0f b6 09             	movzbl (%ecx),%ecx
80103f04:	88 0a                	mov    %cl,(%edx)
80103f06:	84 c9                	test   %cl,%cl
80103f08:	75 e6                	jne    80103ef0 <safestrcpy+0x17>
80103f0a:	89 da                	mov    %ebx,%edx
    ;
  *s = 0;
80103f0c:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80103f0f:	89 f8                	mov    %edi,%eax
80103f11:	5b                   	pop    %ebx
80103f12:	5e                   	pop    %esi
80103f13:	5f                   	pop    %edi
80103f14:	5d                   	pop    %ebp
80103f15:	c3                   	ret    

80103f16 <strlen>:

int
strlen(const char *s)
{
80103f16:	55                   	push   %ebp
80103f17:	89 e5                	mov    %esp,%ebp
80103f19:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80103f1c:	b8 00 00 00 00       	mov    $0x0,%eax
80103f21:	eb 03                	jmp    80103f26 <strlen+0x10>
80103f23:	83 c0 01             	add    $0x1,%eax
80103f26:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103f2a:	75 f7                	jne    80103f23 <strlen+0xd>
    ;
  return n;
}
80103f2c:	5d                   	pop    %ebp
80103f2d:	c3                   	ret    

80103f2e <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80103f2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80103f32:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80103f36:	55                   	push   %ebp
  pushl %ebx
80103f37:	53                   	push   %ebx
  pushl %esi
80103f38:	56                   	push   %esi
  pushl %edi
80103f39:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80103f3a:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80103f3c:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80103f3e:	5f                   	pop    %edi
  popl %esi
80103f3f:	5e                   	pop    %esi
  popl %ebx
80103f40:	5b                   	pop    %ebx
  popl %ebp
80103f41:	5d                   	pop    %ebp
  ret
80103f42:	c3                   	ret    

80103f43 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103f43:	55                   	push   %ebp
80103f44:	89 e5                	mov    %esp,%ebp
80103f46:	53                   	push   %ebx
80103f47:	83 ec 04             	sub    $0x4,%esp
80103f4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103f4d:	e8 70 f2 ff ff       	call   801031c2 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103f52:	8b 00                	mov    (%eax),%eax
80103f54:	39 d8                	cmp    %ebx,%eax
80103f56:	76 18                	jbe    80103f70 <fetchint+0x2d>
80103f58:	8d 53 04             	lea    0x4(%ebx),%edx
80103f5b:	39 d0                	cmp    %edx,%eax
80103f5d:	72 18                	jb     80103f77 <fetchint+0x34>
    return -1;
  *ip = *(int*)(addr);
80103f5f:	8b 13                	mov    (%ebx),%edx
80103f61:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f64:	89 10                	mov    %edx,(%eax)
  return 0;
80103f66:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103f6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f6e:	c9                   	leave  
80103f6f:	c3                   	ret    
    return -1;
80103f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f75:	eb f4                	jmp    80103f6b <fetchint+0x28>
80103f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f7c:	eb ed                	jmp    80103f6b <fetchint+0x28>

80103f7e <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80103f7e:	55                   	push   %ebp
80103f7f:	89 e5                	mov    %esp,%ebp
80103f81:	53                   	push   %ebx
80103f82:	83 ec 04             	sub    $0x4,%esp
80103f85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80103f88:	e8 35 f2 ff ff       	call   801031c2 <myproc>

  if(addr >= curproc->sz)
80103f8d:	39 18                	cmp    %ebx,(%eax)
80103f8f:	76 25                	jbe    80103fb6 <fetchstr+0x38>
    return -1;
  *pp = (char*)addr;
80103f91:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f94:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80103f96:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80103f98:	89 d8                	mov    %ebx,%eax
80103f9a:	eb 03                	jmp    80103f9f <fetchstr+0x21>
80103f9c:	83 c0 01             	add    $0x1,%eax
80103f9f:	39 d0                	cmp    %edx,%eax
80103fa1:	73 09                	jae    80103fac <fetchstr+0x2e>
    if(*s == 0)
80103fa3:	80 38 00             	cmpb   $0x0,(%eax)
80103fa6:	75 f4                	jne    80103f9c <fetchstr+0x1e>
      return s - *pp;
80103fa8:	29 d8                	sub    %ebx,%eax
80103faa:	eb 05                	jmp    80103fb1 <fetchstr+0x33>
  }
  return -1;
80103fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103fb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fb4:	c9                   	leave  
80103fb5:	c3                   	ret    
    return -1;
80103fb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fbb:	eb f4                	jmp    80103fb1 <fetchstr+0x33>

80103fbd <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80103fbd:	55                   	push   %ebp
80103fbe:	89 e5                	mov    %esp,%ebp
80103fc0:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80103fc3:	e8 fa f1 ff ff       	call   801031c2 <myproc>
80103fc8:	8b 50 18             	mov    0x18(%eax),%edx
80103fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fce:	c1 e0 02             	shl    $0x2,%eax
80103fd1:	03 42 44             	add    0x44(%edx),%eax
80103fd4:	83 ec 08             	sub    $0x8,%esp
80103fd7:	ff 75 0c             	push   0xc(%ebp)
80103fda:	83 c0 04             	add    $0x4,%eax
80103fdd:	50                   	push   %eax
80103fde:	e8 60 ff ff ff       	call   80103f43 <fetchint>
}
80103fe3:	c9                   	leave  
80103fe4:	c3                   	ret    

80103fe5 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80103fe5:	55                   	push   %ebp
80103fe6:	89 e5                	mov    %esp,%ebp
80103fe8:	56                   	push   %esi
80103fe9:	53                   	push   %ebx
80103fea:	83 ec 10             	sub    $0x10,%esp
80103fed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80103ff0:	e8 cd f1 ff ff       	call   801031c2 <myproc>
80103ff5:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80103ff7:	83 ec 08             	sub    $0x8,%esp
80103ffa:	8d 45 f4             	lea    -0xc(%ebp),%eax
80103ffd:	50                   	push   %eax
80103ffe:	ff 75 08             	push   0x8(%ebp)
80104001:	e8 b7 ff ff ff       	call   80103fbd <argint>
80104006:	83 c4 10             	add    $0x10,%esp
80104009:	85 c0                	test   %eax,%eax
8010400b:	78 24                	js     80104031 <argptr+0x4c>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010400d:	85 db                	test   %ebx,%ebx
8010400f:	78 27                	js     80104038 <argptr+0x53>
80104011:	8b 16                	mov    (%esi),%edx
80104013:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104016:	39 c2                	cmp    %eax,%edx
80104018:	76 25                	jbe    8010403f <argptr+0x5a>
8010401a:	01 c3                	add    %eax,%ebx
8010401c:	39 da                	cmp    %ebx,%edx
8010401e:	72 26                	jb     80104046 <argptr+0x61>
    return -1;
  *pp = (char*)i;
80104020:	8b 55 0c             	mov    0xc(%ebp),%edx
80104023:	89 02                	mov    %eax,(%edx)
  return 0;
80104025:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010402a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010402d:	5b                   	pop    %ebx
8010402e:	5e                   	pop    %esi
8010402f:	5d                   	pop    %ebp
80104030:	c3                   	ret    
    return -1;
80104031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104036:	eb f2                	jmp    8010402a <argptr+0x45>
    return -1;
80104038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010403d:	eb eb                	jmp    8010402a <argptr+0x45>
8010403f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104044:	eb e4                	jmp    8010402a <argptr+0x45>
80104046:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010404b:	eb dd                	jmp    8010402a <argptr+0x45>

8010404d <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010404d:	55                   	push   %ebp
8010404e:	89 e5                	mov    %esp,%ebp
80104050:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104053:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104056:	50                   	push   %eax
80104057:	ff 75 08             	push   0x8(%ebp)
8010405a:	e8 5e ff ff ff       	call   80103fbd <argint>
8010405f:	83 c4 10             	add    $0x10,%esp
80104062:	85 c0                	test   %eax,%eax
80104064:	78 13                	js     80104079 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
80104066:	83 ec 08             	sub    $0x8,%esp
80104069:	ff 75 0c             	push   0xc(%ebp)
8010406c:	ff 75 f4             	push   -0xc(%ebp)
8010406f:	e8 0a ff ff ff       	call   80103f7e <fetchstr>
80104074:	83 c4 10             	add    $0x10,%esp
}
80104077:	c9                   	leave  
80104078:	c3                   	ret    
    return -1;
80104079:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010407e:	eb f7                	jmp    80104077 <argstr+0x2a>

80104080 <syscall>:
[SYS_munprotect] sys_munprotect,
};

void
syscall(void)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	53                   	push   %ebx
80104084:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104087:	e8 36 f1 ff ff       	call   801031c2 <myproc>
8010408c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010408e:	8b 40 18             	mov    0x18(%eax),%eax
80104091:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104094:	8d 50 ff             	lea    -0x1(%eax),%edx
80104097:	83 fa 18             	cmp    $0x18,%edx
8010409a:	77 17                	ja     801040b3 <syscall+0x33>
8010409c:	8b 14 85 e0 6d 10 80 	mov    -0x7fef9220(,%eax,4),%edx
801040a3:	85 d2                	test   %edx,%edx
801040a5:	74 0c                	je     801040b3 <syscall+0x33>
    curproc->tf->eax = syscalls[num]();
801040a7:	ff d2                	call   *%edx
801040a9:	89 c2                	mov    %eax,%edx
801040ab:	8b 43 18             	mov    0x18(%ebx),%eax
801040ae:	89 50 1c             	mov    %edx,0x1c(%eax)
801040b1:	eb 1f                	jmp    801040d2 <syscall+0x52>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
801040b3:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
801040b6:	50                   	push   %eax
801040b7:	52                   	push   %edx
801040b8:	ff 73 10             	push   0x10(%ebx)
801040bb:	68 bd 6d 10 80       	push   $0x80106dbd
801040c0:	e8 42 c5 ff ff       	call   80100607 <cprintf>
    curproc->tf->eax = -1;
801040c5:	8b 43 18             	mov    0x18(%ebx),%eax
801040c8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801040cf:	83 c4 10             	add    $0x10,%esp
  }
}
801040d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040d5:	c9                   	leave  
801040d6:	c3                   	ret    

801040d7 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801040d7:	55                   	push   %ebp
801040d8:	89 e5                	mov    %esp,%ebp
801040da:	56                   	push   %esi
801040db:	53                   	push   %ebx
801040dc:	83 ec 18             	sub    $0x18,%esp
801040df:	89 d6                	mov    %edx,%esi
801040e1:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801040e3:	8d 55 f4             	lea    -0xc(%ebp),%edx
801040e6:	52                   	push   %edx
801040e7:	50                   	push   %eax
801040e8:	e8 d0 fe ff ff       	call   80103fbd <argint>
801040ed:	83 c4 10             	add    $0x10,%esp
801040f0:	85 c0                	test   %eax,%eax
801040f2:	78 35                	js     80104129 <argfd+0x52>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801040f4:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801040f8:	77 28                	ja     80104122 <argfd+0x4b>
801040fa:	e8 c3 f0 ff ff       	call   801031c2 <myproc>
801040ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104102:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104106:	85 c0                	test   %eax,%eax
80104108:	74 18                	je     80104122 <argfd+0x4b>
    return -1;
  if(pfd)
8010410a:	85 f6                	test   %esi,%esi
8010410c:	74 02                	je     80104110 <argfd+0x39>
    *pfd = fd;
8010410e:	89 16                	mov    %edx,(%esi)
  if(pf)
80104110:	85 db                	test   %ebx,%ebx
80104112:	74 1c                	je     80104130 <argfd+0x59>
    *pf = f;
80104114:	89 03                	mov    %eax,(%ebx)
  return 0;
80104116:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010411b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010411e:	5b                   	pop    %ebx
8010411f:	5e                   	pop    %esi
80104120:	5d                   	pop    %ebp
80104121:	c3                   	ret    
    return -1;
80104122:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104127:	eb f2                	jmp    8010411b <argfd+0x44>
    return -1;
80104129:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010412e:	eb eb                	jmp    8010411b <argfd+0x44>
  return 0;
80104130:	b8 00 00 00 00       	mov    $0x0,%eax
80104135:	eb e4                	jmp    8010411b <argfd+0x44>

80104137 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104137:	55                   	push   %ebp
80104138:	89 e5                	mov    %esp,%ebp
8010413a:	53                   	push   %ebx
8010413b:	83 ec 04             	sub    $0x4,%esp
8010413e:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
80104140:	e8 7d f0 ff ff       	call   801031c2 <myproc>
80104145:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
80104147:	b8 00 00 00 00       	mov    $0x0,%eax
8010414c:	83 f8 0f             	cmp    $0xf,%eax
8010414f:	7f 12                	jg     80104163 <fdalloc+0x2c>
    if(curproc->ofile[fd] == 0){
80104151:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
80104156:	74 05                	je     8010415d <fdalloc+0x26>
  for(fd = 0; fd < NOFILE; fd++){
80104158:	83 c0 01             	add    $0x1,%eax
8010415b:	eb ef                	jmp    8010414c <fdalloc+0x15>
      curproc->ofile[fd] = f;
8010415d:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
80104161:	eb 05                	jmp    80104168 <fdalloc+0x31>
    }
  }
  return -1;
80104163:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104168:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010416b:	c9                   	leave  
8010416c:	c3                   	ret    

8010416d <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010416d:	55                   	push   %ebp
8010416e:	89 e5                	mov    %esp,%ebp
80104170:	56                   	push   %esi
80104171:	53                   	push   %ebx
80104172:	83 ec 10             	sub    $0x10,%esp
80104175:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104177:	b8 20 00 00 00       	mov    $0x20,%eax
8010417c:	89 c6                	mov    %eax,%esi
8010417e:	39 43 58             	cmp    %eax,0x58(%ebx)
80104181:	76 2e                	jbe    801041b1 <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104183:	6a 10                	push   $0x10
80104185:	50                   	push   %eax
80104186:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104189:	50                   	push   %eax
8010418a:	53                   	push   %ebx
8010418b:	e8 d1 d5 ff ff       	call   80101761 <readi>
80104190:	83 c4 10             	add    $0x10,%esp
80104193:	83 f8 10             	cmp    $0x10,%eax
80104196:	75 0c                	jne    801041a4 <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104198:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
8010419d:	75 1e                	jne    801041bd <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010419f:	8d 46 10             	lea    0x10(%esi),%eax
801041a2:	eb d8                	jmp    8010417c <isdirempty+0xf>
      panic("isdirempty: readi");
801041a4:	83 ec 0c             	sub    $0xc,%esp
801041a7:	68 48 6e 10 80       	push   $0x80106e48
801041ac:	e8 97 c1 ff ff       	call   80100348 <panic>
      return 0;
  }
  return 1;
801041b1:	b8 01 00 00 00       	mov    $0x1,%eax
}
801041b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041b9:	5b                   	pop    %ebx
801041ba:	5e                   	pop    %esi
801041bb:	5d                   	pop    %ebp
801041bc:	c3                   	ret    
      return 0;
801041bd:	b8 00 00 00 00       	mov    $0x0,%eax
801041c2:	eb f2                	jmp    801041b6 <isdirempty+0x49>

801041c4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801041c4:	55                   	push   %ebp
801041c5:	89 e5                	mov    %esp,%ebp
801041c7:	57                   	push   %edi
801041c8:	56                   	push   %esi
801041c9:	53                   	push   %ebx
801041ca:	83 ec 34             	sub    $0x34,%esp
801041cd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801041d0:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801041d3:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801041d6:	8d 55 da             	lea    -0x26(%ebp),%edx
801041d9:	52                   	push   %edx
801041da:	50                   	push   %eax
801041db:	e8 05 da ff ff       	call   80101be5 <nameiparent>
801041e0:	89 c6                	mov    %eax,%esi
801041e2:	83 c4 10             	add    $0x10,%esp
801041e5:	85 c0                	test   %eax,%eax
801041e7:	0f 84 33 01 00 00    	je     80104320 <create+0x15c>
    return 0;
  ilock(dp);
801041ed:	83 ec 0c             	sub    $0xc,%esp
801041f0:	50                   	push   %eax
801041f1:	e8 79 d3 ff ff       	call   8010156f <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801041f6:	83 c4 0c             	add    $0xc,%esp
801041f9:	6a 00                	push   $0x0
801041fb:	8d 45 da             	lea    -0x26(%ebp),%eax
801041fe:	50                   	push   %eax
801041ff:	56                   	push   %esi
80104200:	e8 9a d7 ff ff       	call   8010199f <dirlookup>
80104205:	89 c3                	mov    %eax,%ebx
80104207:	83 c4 10             	add    $0x10,%esp
8010420a:	85 c0                	test   %eax,%eax
8010420c:	74 3d                	je     8010424b <create+0x87>
    iunlockput(dp);
8010420e:	83 ec 0c             	sub    $0xc,%esp
80104211:	56                   	push   %esi
80104212:	e8 ff d4 ff ff       	call   80101716 <iunlockput>
    ilock(ip);
80104217:	89 1c 24             	mov    %ebx,(%esp)
8010421a:	e8 50 d3 ff ff       	call   8010156f <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010421f:	83 c4 10             	add    $0x10,%esp
80104222:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104227:	75 07                	jne    80104230 <create+0x6c>
80104229:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010422e:	74 11                	je     80104241 <create+0x7d>
      return ip;
    iunlockput(ip);
80104230:	83 ec 0c             	sub    $0xc,%esp
80104233:	53                   	push   %ebx
80104234:	e8 dd d4 ff ff       	call   80101716 <iunlockput>
    return 0;
80104239:	83 c4 10             	add    $0x10,%esp
8010423c:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104241:	89 d8                	mov    %ebx,%eax
80104243:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104246:	5b                   	pop    %ebx
80104247:	5e                   	pop    %esi
80104248:	5f                   	pop    %edi
80104249:	5d                   	pop    %ebp
8010424a:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
8010424b:	83 ec 08             	sub    $0x8,%esp
8010424e:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104252:	50                   	push   %eax
80104253:	ff 36                	push   (%esi)
80104255:	e8 12 d1 ff ff       	call   8010136c <ialloc>
8010425a:	89 c3                	mov    %eax,%ebx
8010425c:	83 c4 10             	add    $0x10,%esp
8010425f:	85 c0                	test   %eax,%eax
80104261:	74 52                	je     801042b5 <create+0xf1>
  ilock(ip);
80104263:	83 ec 0c             	sub    $0xc,%esp
80104266:	50                   	push   %eax
80104267:	e8 03 d3 ff ff       	call   8010156f <ilock>
  ip->major = major;
8010426c:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104270:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104274:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
80104278:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
8010427e:	89 1c 24             	mov    %ebx,(%esp)
80104281:	e8 88 d1 ff ff       	call   8010140e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104286:	83 c4 10             	add    $0x10,%esp
80104289:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010428e:	74 32                	je     801042c2 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
80104290:	83 ec 04             	sub    $0x4,%esp
80104293:	ff 73 04             	push   0x4(%ebx)
80104296:	8d 45 da             	lea    -0x26(%ebp),%eax
80104299:	50                   	push   %eax
8010429a:	56                   	push   %esi
8010429b:	e8 7c d8 ff ff       	call   80101b1c <dirlink>
801042a0:	83 c4 10             	add    $0x10,%esp
801042a3:	85 c0                	test   %eax,%eax
801042a5:	78 6c                	js     80104313 <create+0x14f>
  iunlockput(dp);
801042a7:	83 ec 0c             	sub    $0xc,%esp
801042aa:	56                   	push   %esi
801042ab:	e8 66 d4 ff ff       	call   80101716 <iunlockput>
  return ip;
801042b0:	83 c4 10             	add    $0x10,%esp
801042b3:	eb 8c                	jmp    80104241 <create+0x7d>
    panic("create: ialloc");
801042b5:	83 ec 0c             	sub    $0xc,%esp
801042b8:	68 5a 6e 10 80       	push   $0x80106e5a
801042bd:	e8 86 c0 ff ff       	call   80100348 <panic>
    dp->nlink++;  // for ".."
801042c2:	0f b7 46 56          	movzwl 0x56(%esi),%eax
801042c6:	83 c0 01             	add    $0x1,%eax
801042c9:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
801042cd:	83 ec 0c             	sub    $0xc,%esp
801042d0:	56                   	push   %esi
801042d1:	e8 38 d1 ff ff       	call   8010140e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801042d6:	83 c4 0c             	add    $0xc,%esp
801042d9:	ff 73 04             	push   0x4(%ebx)
801042dc:	68 6a 6e 10 80       	push   $0x80106e6a
801042e1:	53                   	push   %ebx
801042e2:	e8 35 d8 ff ff       	call   80101b1c <dirlink>
801042e7:	83 c4 10             	add    $0x10,%esp
801042ea:	85 c0                	test   %eax,%eax
801042ec:	78 18                	js     80104306 <create+0x142>
801042ee:	83 ec 04             	sub    $0x4,%esp
801042f1:	ff 76 04             	push   0x4(%esi)
801042f4:	68 69 6e 10 80       	push   $0x80106e69
801042f9:	53                   	push   %ebx
801042fa:	e8 1d d8 ff ff       	call   80101b1c <dirlink>
801042ff:	83 c4 10             	add    $0x10,%esp
80104302:	85 c0                	test   %eax,%eax
80104304:	79 8a                	jns    80104290 <create+0xcc>
      panic("create dots");
80104306:	83 ec 0c             	sub    $0xc,%esp
80104309:	68 6c 6e 10 80       	push   $0x80106e6c
8010430e:	e8 35 c0 ff ff       	call   80100348 <panic>
    panic("create: dirlink");
80104313:	83 ec 0c             	sub    $0xc,%esp
80104316:	68 78 6e 10 80       	push   $0x80106e78
8010431b:	e8 28 c0 ff ff       	call   80100348 <panic>
    return 0;
80104320:	89 c3                	mov    %eax,%ebx
80104322:	e9 1a ff ff ff       	jmp    80104241 <create+0x7d>

80104327 <sys_dup>:
{
80104327:	55                   	push   %ebp
80104328:	89 e5                	mov    %esp,%ebp
8010432a:	53                   	push   %ebx
8010432b:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
8010432e:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104331:	ba 00 00 00 00       	mov    $0x0,%edx
80104336:	b8 00 00 00 00       	mov    $0x0,%eax
8010433b:	e8 97 fd ff ff       	call   801040d7 <argfd>
80104340:	85 c0                	test   %eax,%eax
80104342:	78 23                	js     80104367 <sys_dup+0x40>
  if((fd=fdalloc(f)) < 0)
80104344:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104347:	e8 eb fd ff ff       	call   80104137 <fdalloc>
8010434c:	89 c3                	mov    %eax,%ebx
8010434e:	85 c0                	test   %eax,%eax
80104350:	78 1c                	js     8010436e <sys_dup+0x47>
  filedup(f);
80104352:	83 ec 0c             	sub    $0xc,%esp
80104355:	ff 75 f4             	push   -0xc(%ebp)
80104358:	e8 21 c9 ff ff       	call   80100c7e <filedup>
  return fd;
8010435d:	83 c4 10             	add    $0x10,%esp
}
80104360:	89 d8                	mov    %ebx,%eax
80104362:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104365:	c9                   	leave  
80104366:	c3                   	ret    
    return -1;
80104367:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010436c:	eb f2                	jmp    80104360 <sys_dup+0x39>
    return -1;
8010436e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104373:	eb eb                	jmp    80104360 <sys_dup+0x39>

80104375 <sys_read>:
{
80104375:	55                   	push   %ebp
80104376:	89 e5                	mov    %esp,%ebp
80104378:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010437b:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010437e:	ba 00 00 00 00       	mov    $0x0,%edx
80104383:	b8 00 00 00 00       	mov    $0x0,%eax
80104388:	e8 4a fd ff ff       	call   801040d7 <argfd>
8010438d:	85 c0                	test   %eax,%eax
8010438f:	78 43                	js     801043d4 <sys_read+0x5f>
80104391:	83 ec 08             	sub    $0x8,%esp
80104394:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104397:	50                   	push   %eax
80104398:	6a 02                	push   $0x2
8010439a:	e8 1e fc ff ff       	call   80103fbd <argint>
8010439f:	83 c4 10             	add    $0x10,%esp
801043a2:	85 c0                	test   %eax,%eax
801043a4:	78 2e                	js     801043d4 <sys_read+0x5f>
801043a6:	83 ec 04             	sub    $0x4,%esp
801043a9:	ff 75 f0             	push   -0x10(%ebp)
801043ac:	8d 45 ec             	lea    -0x14(%ebp),%eax
801043af:	50                   	push   %eax
801043b0:	6a 01                	push   $0x1
801043b2:	e8 2e fc ff ff       	call   80103fe5 <argptr>
801043b7:	83 c4 10             	add    $0x10,%esp
801043ba:	85 c0                	test   %eax,%eax
801043bc:	78 16                	js     801043d4 <sys_read+0x5f>
  return fileread(f, p, n);
801043be:	83 ec 04             	sub    $0x4,%esp
801043c1:	ff 75 f0             	push   -0x10(%ebp)
801043c4:	ff 75 ec             	push   -0x14(%ebp)
801043c7:	ff 75 f4             	push   -0xc(%ebp)
801043ca:	e8 01 ca ff ff       	call   80100dd0 <fileread>
801043cf:	83 c4 10             	add    $0x10,%esp
}
801043d2:	c9                   	leave  
801043d3:	c3                   	ret    
    return -1;
801043d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043d9:	eb f7                	jmp    801043d2 <sys_read+0x5d>

801043db <sys_write>:
{
801043db:	55                   	push   %ebp
801043dc:	89 e5                	mov    %esp,%ebp
801043de:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801043e1:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043e4:	ba 00 00 00 00       	mov    $0x0,%edx
801043e9:	b8 00 00 00 00       	mov    $0x0,%eax
801043ee:	e8 e4 fc ff ff       	call   801040d7 <argfd>
801043f3:	85 c0                	test   %eax,%eax
801043f5:	78 43                	js     8010443a <sys_write+0x5f>
801043f7:	83 ec 08             	sub    $0x8,%esp
801043fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801043fd:	50                   	push   %eax
801043fe:	6a 02                	push   $0x2
80104400:	e8 b8 fb ff ff       	call   80103fbd <argint>
80104405:	83 c4 10             	add    $0x10,%esp
80104408:	85 c0                	test   %eax,%eax
8010440a:	78 2e                	js     8010443a <sys_write+0x5f>
8010440c:	83 ec 04             	sub    $0x4,%esp
8010440f:	ff 75 f0             	push   -0x10(%ebp)
80104412:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104415:	50                   	push   %eax
80104416:	6a 01                	push   $0x1
80104418:	e8 c8 fb ff ff       	call   80103fe5 <argptr>
8010441d:	83 c4 10             	add    $0x10,%esp
80104420:	85 c0                	test   %eax,%eax
80104422:	78 16                	js     8010443a <sys_write+0x5f>
  return filewrite(f, p, n);
80104424:	83 ec 04             	sub    $0x4,%esp
80104427:	ff 75 f0             	push   -0x10(%ebp)
8010442a:	ff 75 ec             	push   -0x14(%ebp)
8010442d:	ff 75 f4             	push   -0xc(%ebp)
80104430:	e8 20 ca ff ff       	call   80100e55 <filewrite>
80104435:	83 c4 10             	add    $0x10,%esp
}
80104438:	c9                   	leave  
80104439:	c3                   	ret    
    return -1;
8010443a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010443f:	eb f7                	jmp    80104438 <sys_write+0x5d>

80104441 <sys_close>:
{
80104441:	55                   	push   %ebp
80104442:	89 e5                	mov    %esp,%ebp
80104444:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104447:	8d 4d f0             	lea    -0x10(%ebp),%ecx
8010444a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010444d:	b8 00 00 00 00       	mov    $0x0,%eax
80104452:	e8 80 fc ff ff       	call   801040d7 <argfd>
80104457:	85 c0                	test   %eax,%eax
80104459:	78 25                	js     80104480 <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
8010445b:	e8 62 ed ff ff       	call   801031c2 <myproc>
80104460:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104463:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010446a:	00 
  fileclose(f);
8010446b:	83 ec 0c             	sub    $0xc,%esp
8010446e:	ff 75 f0             	push   -0x10(%ebp)
80104471:	e8 4d c8 ff ff       	call   80100cc3 <fileclose>
  return 0;
80104476:	83 c4 10             	add    $0x10,%esp
80104479:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010447e:	c9                   	leave  
8010447f:	c3                   	ret    
    return -1;
80104480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104485:	eb f7                	jmp    8010447e <sys_close+0x3d>

80104487 <sys_fstat>:
{
80104487:	55                   	push   %ebp
80104488:	89 e5                	mov    %esp,%ebp
8010448a:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010448d:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104490:	ba 00 00 00 00       	mov    $0x0,%edx
80104495:	b8 00 00 00 00       	mov    $0x0,%eax
8010449a:	e8 38 fc ff ff       	call   801040d7 <argfd>
8010449f:	85 c0                	test   %eax,%eax
801044a1:	78 2a                	js     801044cd <sys_fstat+0x46>
801044a3:	83 ec 04             	sub    $0x4,%esp
801044a6:	6a 14                	push   $0x14
801044a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801044ab:	50                   	push   %eax
801044ac:	6a 01                	push   $0x1
801044ae:	e8 32 fb ff ff       	call   80103fe5 <argptr>
801044b3:	83 c4 10             	add    $0x10,%esp
801044b6:	85 c0                	test   %eax,%eax
801044b8:	78 13                	js     801044cd <sys_fstat+0x46>
  return filestat(f, st);
801044ba:	83 ec 08             	sub    $0x8,%esp
801044bd:	ff 75 f0             	push   -0x10(%ebp)
801044c0:	ff 75 f4             	push   -0xc(%ebp)
801044c3:	e8 c1 c8 ff ff       	call   80100d89 <filestat>
801044c8:	83 c4 10             	add    $0x10,%esp
}
801044cb:	c9                   	leave  
801044cc:	c3                   	ret    
    return -1;
801044cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044d2:	eb f7                	jmp    801044cb <sys_fstat+0x44>

801044d4 <sys_link>:
{
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	56                   	push   %esi
801044d8:	53                   	push   %ebx
801044d9:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801044dc:	8d 45 e0             	lea    -0x20(%ebp),%eax
801044df:	50                   	push   %eax
801044e0:	6a 00                	push   $0x0
801044e2:	e8 66 fb ff ff       	call   8010404d <argstr>
801044e7:	83 c4 10             	add    $0x10,%esp
801044ea:	85 c0                	test   %eax,%eax
801044ec:	0f 88 d3 00 00 00    	js     801045c5 <sys_link+0xf1>
801044f2:	83 ec 08             	sub    $0x8,%esp
801044f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801044f8:	50                   	push   %eax
801044f9:	6a 01                	push   $0x1
801044fb:	e8 4d fb ff ff       	call   8010404d <argstr>
80104500:	83 c4 10             	add    $0x10,%esp
80104503:	85 c0                	test   %eax,%eax
80104505:	0f 88 ba 00 00 00    	js     801045c5 <sys_link+0xf1>
  begin_op();
8010450b:	e8 6e e2 ff ff       	call   8010277e <begin_op>
  if((ip = namei(old)) == 0){
80104510:	83 ec 0c             	sub    $0xc,%esp
80104513:	ff 75 e0             	push   -0x20(%ebp)
80104516:	e8 b2 d6 ff ff       	call   80101bcd <namei>
8010451b:	89 c3                	mov    %eax,%ebx
8010451d:	83 c4 10             	add    $0x10,%esp
80104520:	85 c0                	test   %eax,%eax
80104522:	0f 84 a4 00 00 00    	je     801045cc <sys_link+0xf8>
  ilock(ip);
80104528:	83 ec 0c             	sub    $0xc,%esp
8010452b:	50                   	push   %eax
8010452c:	e8 3e d0 ff ff       	call   8010156f <ilock>
  if(ip->type == T_DIR){
80104531:	83 c4 10             	add    $0x10,%esp
80104534:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104539:	0f 84 99 00 00 00    	je     801045d8 <sys_link+0x104>
  ip->nlink++;
8010453f:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104543:	83 c0 01             	add    $0x1,%eax
80104546:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010454a:	83 ec 0c             	sub    $0xc,%esp
8010454d:	53                   	push   %ebx
8010454e:	e8 bb ce ff ff       	call   8010140e <iupdate>
  iunlock(ip);
80104553:	89 1c 24             	mov    %ebx,(%esp)
80104556:	e8 d6 d0 ff ff       	call   80101631 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
8010455b:	83 c4 08             	add    $0x8,%esp
8010455e:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104561:	50                   	push   %eax
80104562:	ff 75 e4             	push   -0x1c(%ebp)
80104565:	e8 7b d6 ff ff       	call   80101be5 <nameiparent>
8010456a:	89 c6                	mov    %eax,%esi
8010456c:	83 c4 10             	add    $0x10,%esp
8010456f:	85 c0                	test   %eax,%eax
80104571:	0f 84 85 00 00 00    	je     801045fc <sys_link+0x128>
  ilock(dp);
80104577:	83 ec 0c             	sub    $0xc,%esp
8010457a:	50                   	push   %eax
8010457b:	e8 ef cf ff ff       	call   8010156f <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104580:	83 c4 10             	add    $0x10,%esp
80104583:	8b 03                	mov    (%ebx),%eax
80104585:	39 06                	cmp    %eax,(%esi)
80104587:	75 67                	jne    801045f0 <sys_link+0x11c>
80104589:	83 ec 04             	sub    $0x4,%esp
8010458c:	ff 73 04             	push   0x4(%ebx)
8010458f:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104592:	50                   	push   %eax
80104593:	56                   	push   %esi
80104594:	e8 83 d5 ff ff       	call   80101b1c <dirlink>
80104599:	83 c4 10             	add    $0x10,%esp
8010459c:	85 c0                	test   %eax,%eax
8010459e:	78 50                	js     801045f0 <sys_link+0x11c>
  iunlockput(dp);
801045a0:	83 ec 0c             	sub    $0xc,%esp
801045a3:	56                   	push   %esi
801045a4:	e8 6d d1 ff ff       	call   80101716 <iunlockput>
  iput(ip);
801045a9:	89 1c 24             	mov    %ebx,(%esp)
801045ac:	e8 c5 d0 ff ff       	call   80101676 <iput>
  end_op();
801045b1:	e8 42 e2 ff ff       	call   801027f8 <end_op>
  return 0;
801045b6:	83 c4 10             	add    $0x10,%esp
801045b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801045be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045c1:	5b                   	pop    %ebx
801045c2:	5e                   	pop    %esi
801045c3:	5d                   	pop    %ebp
801045c4:	c3                   	ret    
    return -1;
801045c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045ca:	eb f2                	jmp    801045be <sys_link+0xea>
    end_op();
801045cc:	e8 27 e2 ff ff       	call   801027f8 <end_op>
    return -1;
801045d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045d6:	eb e6                	jmp    801045be <sys_link+0xea>
    iunlockput(ip);
801045d8:	83 ec 0c             	sub    $0xc,%esp
801045db:	53                   	push   %ebx
801045dc:	e8 35 d1 ff ff       	call   80101716 <iunlockput>
    end_op();
801045e1:	e8 12 e2 ff ff       	call   801027f8 <end_op>
    return -1;
801045e6:	83 c4 10             	add    $0x10,%esp
801045e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045ee:	eb ce                	jmp    801045be <sys_link+0xea>
    iunlockput(dp);
801045f0:	83 ec 0c             	sub    $0xc,%esp
801045f3:	56                   	push   %esi
801045f4:	e8 1d d1 ff ff       	call   80101716 <iunlockput>
    goto bad;
801045f9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801045fc:	83 ec 0c             	sub    $0xc,%esp
801045ff:	53                   	push   %ebx
80104600:	e8 6a cf ff ff       	call   8010156f <ilock>
  ip->nlink--;
80104605:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104609:	83 e8 01             	sub    $0x1,%eax
8010460c:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104610:	89 1c 24             	mov    %ebx,(%esp)
80104613:	e8 f6 cd ff ff       	call   8010140e <iupdate>
  iunlockput(ip);
80104618:	89 1c 24             	mov    %ebx,(%esp)
8010461b:	e8 f6 d0 ff ff       	call   80101716 <iunlockput>
  end_op();
80104620:	e8 d3 e1 ff ff       	call   801027f8 <end_op>
  return -1;
80104625:	83 c4 10             	add    $0x10,%esp
80104628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010462d:	eb 8f                	jmp    801045be <sys_link+0xea>

8010462f <sys_unlink>:
{
8010462f:	55                   	push   %ebp
80104630:	89 e5                	mov    %esp,%ebp
80104632:	57                   	push   %edi
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80104638:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010463b:	50                   	push   %eax
8010463c:	6a 00                	push   $0x0
8010463e:	e8 0a fa ff ff       	call   8010404d <argstr>
80104643:	83 c4 10             	add    $0x10,%esp
80104646:	85 c0                	test   %eax,%eax
80104648:	0f 88 83 01 00 00    	js     801047d1 <sys_unlink+0x1a2>
  begin_op();
8010464e:	e8 2b e1 ff ff       	call   8010277e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104653:	83 ec 08             	sub    $0x8,%esp
80104656:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104659:	50                   	push   %eax
8010465a:	ff 75 c4             	push   -0x3c(%ebp)
8010465d:	e8 83 d5 ff ff       	call   80101be5 <nameiparent>
80104662:	89 c6                	mov    %eax,%esi
80104664:	83 c4 10             	add    $0x10,%esp
80104667:	85 c0                	test   %eax,%eax
80104669:	0f 84 ed 00 00 00    	je     8010475c <sys_unlink+0x12d>
  ilock(dp);
8010466f:	83 ec 0c             	sub    $0xc,%esp
80104672:	50                   	push   %eax
80104673:	e8 f7 ce ff ff       	call   8010156f <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104678:	83 c4 08             	add    $0x8,%esp
8010467b:	68 6a 6e 10 80       	push   $0x80106e6a
80104680:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104683:	50                   	push   %eax
80104684:	e8 01 d3 ff ff       	call   8010198a <namecmp>
80104689:	83 c4 10             	add    $0x10,%esp
8010468c:	85 c0                	test   %eax,%eax
8010468e:	0f 84 fc 00 00 00    	je     80104790 <sys_unlink+0x161>
80104694:	83 ec 08             	sub    $0x8,%esp
80104697:	68 69 6e 10 80       	push   $0x80106e69
8010469c:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010469f:	50                   	push   %eax
801046a0:	e8 e5 d2 ff ff       	call   8010198a <namecmp>
801046a5:	83 c4 10             	add    $0x10,%esp
801046a8:	85 c0                	test   %eax,%eax
801046aa:	0f 84 e0 00 00 00    	je     80104790 <sys_unlink+0x161>
  if((ip = dirlookup(dp, name, &off)) == 0)
801046b0:	83 ec 04             	sub    $0x4,%esp
801046b3:	8d 45 c0             	lea    -0x40(%ebp),%eax
801046b6:	50                   	push   %eax
801046b7:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046ba:	50                   	push   %eax
801046bb:	56                   	push   %esi
801046bc:	e8 de d2 ff ff       	call   8010199f <dirlookup>
801046c1:	89 c3                	mov    %eax,%ebx
801046c3:	83 c4 10             	add    $0x10,%esp
801046c6:	85 c0                	test   %eax,%eax
801046c8:	0f 84 c2 00 00 00    	je     80104790 <sys_unlink+0x161>
  ilock(ip);
801046ce:	83 ec 0c             	sub    $0xc,%esp
801046d1:	50                   	push   %eax
801046d2:	e8 98 ce ff ff       	call   8010156f <ilock>
  if(ip->nlink < 1)
801046d7:	83 c4 10             	add    $0x10,%esp
801046da:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801046df:	0f 8e 83 00 00 00    	jle    80104768 <sys_unlink+0x139>
  if(ip->type == T_DIR && !isdirempty(ip)){
801046e5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801046ea:	0f 84 85 00 00 00    	je     80104775 <sys_unlink+0x146>
  memset(&de, 0, sizeof(de));
801046f0:	83 ec 04             	sub    $0x4,%esp
801046f3:	6a 10                	push   $0x10
801046f5:	6a 00                	push   $0x0
801046f7:	8d 7d d8             	lea    -0x28(%ebp),%edi
801046fa:	57                   	push   %edi
801046fb:	e8 6d f6 ff ff       	call   80103d6d <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104700:	6a 10                	push   $0x10
80104702:	ff 75 c0             	push   -0x40(%ebp)
80104705:	57                   	push   %edi
80104706:	56                   	push   %esi
80104707:	e8 52 d1 ff ff       	call   8010185e <writei>
8010470c:	83 c4 20             	add    $0x20,%esp
8010470f:	83 f8 10             	cmp    $0x10,%eax
80104712:	0f 85 90 00 00 00    	jne    801047a8 <sys_unlink+0x179>
  if(ip->type == T_DIR){
80104718:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010471d:	0f 84 92 00 00 00    	je     801047b5 <sys_unlink+0x186>
  iunlockput(dp);
80104723:	83 ec 0c             	sub    $0xc,%esp
80104726:	56                   	push   %esi
80104727:	e8 ea cf ff ff       	call   80101716 <iunlockput>
  ip->nlink--;
8010472c:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104730:	83 e8 01             	sub    $0x1,%eax
80104733:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104737:	89 1c 24             	mov    %ebx,(%esp)
8010473a:	e8 cf cc ff ff       	call   8010140e <iupdate>
  iunlockput(ip);
8010473f:	89 1c 24             	mov    %ebx,(%esp)
80104742:	e8 cf cf ff ff       	call   80101716 <iunlockput>
  end_op();
80104747:	e8 ac e0 ff ff       	call   801027f8 <end_op>
  return 0;
8010474c:	83 c4 10             	add    $0x10,%esp
8010474f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104754:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104757:	5b                   	pop    %ebx
80104758:	5e                   	pop    %esi
80104759:	5f                   	pop    %edi
8010475a:	5d                   	pop    %ebp
8010475b:	c3                   	ret    
    end_op();
8010475c:	e8 97 e0 ff ff       	call   801027f8 <end_op>
    return -1;
80104761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104766:	eb ec                	jmp    80104754 <sys_unlink+0x125>
    panic("unlink: nlink < 1");
80104768:	83 ec 0c             	sub    $0xc,%esp
8010476b:	68 88 6e 10 80       	push   $0x80106e88
80104770:	e8 d3 bb ff ff       	call   80100348 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104775:	89 d8                	mov    %ebx,%eax
80104777:	e8 f1 f9 ff ff       	call   8010416d <isdirempty>
8010477c:	85 c0                	test   %eax,%eax
8010477e:	0f 85 6c ff ff ff    	jne    801046f0 <sys_unlink+0xc1>
    iunlockput(ip);
80104784:	83 ec 0c             	sub    $0xc,%esp
80104787:	53                   	push   %ebx
80104788:	e8 89 cf ff ff       	call   80101716 <iunlockput>
    goto bad;
8010478d:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104790:	83 ec 0c             	sub    $0xc,%esp
80104793:	56                   	push   %esi
80104794:	e8 7d cf ff ff       	call   80101716 <iunlockput>
  end_op();
80104799:	e8 5a e0 ff ff       	call   801027f8 <end_op>
  return -1;
8010479e:	83 c4 10             	add    $0x10,%esp
801047a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047a6:	eb ac                	jmp    80104754 <sys_unlink+0x125>
    panic("unlink: writei");
801047a8:	83 ec 0c             	sub    $0xc,%esp
801047ab:	68 9a 6e 10 80       	push   $0x80106e9a
801047b0:	e8 93 bb ff ff       	call   80100348 <panic>
    dp->nlink--;
801047b5:	0f b7 46 56          	movzwl 0x56(%esi),%eax
801047b9:	83 e8 01             	sub    $0x1,%eax
801047bc:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
801047c0:	83 ec 0c             	sub    $0xc,%esp
801047c3:	56                   	push   %esi
801047c4:	e8 45 cc ff ff       	call   8010140e <iupdate>
801047c9:	83 c4 10             	add    $0x10,%esp
801047cc:	e9 52 ff ff ff       	jmp    80104723 <sys_unlink+0xf4>
    return -1;
801047d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047d6:	e9 79 ff ff ff       	jmp    80104754 <sys_unlink+0x125>

801047db <sys_open>:

int
sys_open(void)
{
801047db:	55                   	push   %ebp
801047dc:	89 e5                	mov    %esp,%ebp
801047de:	57                   	push   %edi
801047df:	56                   	push   %esi
801047e0:	53                   	push   %ebx
801047e1:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801047e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801047e7:	50                   	push   %eax
801047e8:	6a 00                	push   $0x0
801047ea:	e8 5e f8 ff ff       	call   8010404d <argstr>
801047ef:	83 c4 10             	add    $0x10,%esp
801047f2:	85 c0                	test   %eax,%eax
801047f4:	0f 88 a0 00 00 00    	js     8010489a <sys_open+0xbf>
801047fa:	83 ec 08             	sub    $0x8,%esp
801047fd:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104800:	50                   	push   %eax
80104801:	6a 01                	push   $0x1
80104803:	e8 b5 f7 ff ff       	call   80103fbd <argint>
80104808:	83 c4 10             	add    $0x10,%esp
8010480b:	85 c0                	test   %eax,%eax
8010480d:	0f 88 87 00 00 00    	js     8010489a <sys_open+0xbf>
    return -1;

  begin_op();
80104813:	e8 66 df ff ff       	call   8010277e <begin_op>

  if(omode & O_CREATE){
80104818:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
8010481c:	0f 84 8b 00 00 00    	je     801048ad <sys_open+0xd2>
    ip = create(path, T_FILE, 0, 0);
80104822:	83 ec 0c             	sub    $0xc,%esp
80104825:	6a 00                	push   $0x0
80104827:	b9 00 00 00 00       	mov    $0x0,%ecx
8010482c:	ba 02 00 00 00       	mov    $0x2,%edx
80104831:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104834:	e8 8b f9 ff ff       	call   801041c4 <create>
80104839:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010483b:	83 c4 10             	add    $0x10,%esp
8010483e:	85 c0                	test   %eax,%eax
80104840:	74 5f                	je     801048a1 <sys_open+0xc6>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104842:	e8 d6 c3 ff ff       	call   80100c1d <filealloc>
80104847:	89 c3                	mov    %eax,%ebx
80104849:	85 c0                	test   %eax,%eax
8010484b:	0f 84 b5 00 00 00    	je     80104906 <sys_open+0x12b>
80104851:	e8 e1 f8 ff ff       	call   80104137 <fdalloc>
80104856:	89 c7                	mov    %eax,%edi
80104858:	85 c0                	test   %eax,%eax
8010485a:	0f 88 a6 00 00 00    	js     80104906 <sys_open+0x12b>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104860:	83 ec 0c             	sub    $0xc,%esp
80104863:	56                   	push   %esi
80104864:	e8 c8 cd ff ff       	call   80101631 <iunlock>
  end_op();
80104869:	e8 8a df ff ff       	call   801027f8 <end_op>

  f->type = FD_INODE;
8010486e:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104874:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104877:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
8010487e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104881:	83 c4 10             	add    $0x10,%esp
80104884:	a8 01                	test   $0x1,%al
80104886:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010488a:	a8 03                	test   $0x3,%al
8010488c:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104890:	89 f8                	mov    %edi,%eax
80104892:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104895:	5b                   	pop    %ebx
80104896:	5e                   	pop    %esi
80104897:	5f                   	pop    %edi
80104898:	5d                   	pop    %ebp
80104899:	c3                   	ret    
    return -1;
8010489a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010489f:	eb ef                	jmp    80104890 <sys_open+0xb5>
      end_op();
801048a1:	e8 52 df ff ff       	call   801027f8 <end_op>
      return -1;
801048a6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801048ab:	eb e3                	jmp    80104890 <sys_open+0xb5>
    if((ip = namei(path)) == 0){
801048ad:	83 ec 0c             	sub    $0xc,%esp
801048b0:	ff 75 e4             	push   -0x1c(%ebp)
801048b3:	e8 15 d3 ff ff       	call   80101bcd <namei>
801048b8:	89 c6                	mov    %eax,%esi
801048ba:	83 c4 10             	add    $0x10,%esp
801048bd:	85 c0                	test   %eax,%eax
801048bf:	74 39                	je     801048fa <sys_open+0x11f>
    ilock(ip);
801048c1:	83 ec 0c             	sub    $0xc,%esp
801048c4:	50                   	push   %eax
801048c5:	e8 a5 cc ff ff       	call   8010156f <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801048ca:	83 c4 10             	add    $0x10,%esp
801048cd:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801048d2:	0f 85 6a ff ff ff    	jne    80104842 <sys_open+0x67>
801048d8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801048dc:	0f 84 60 ff ff ff    	je     80104842 <sys_open+0x67>
      iunlockput(ip);
801048e2:	83 ec 0c             	sub    $0xc,%esp
801048e5:	56                   	push   %esi
801048e6:	e8 2b ce ff ff       	call   80101716 <iunlockput>
      end_op();
801048eb:	e8 08 df ff ff       	call   801027f8 <end_op>
      return -1;
801048f0:	83 c4 10             	add    $0x10,%esp
801048f3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801048f8:	eb 96                	jmp    80104890 <sys_open+0xb5>
      end_op();
801048fa:	e8 f9 de ff ff       	call   801027f8 <end_op>
      return -1;
801048ff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104904:	eb 8a                	jmp    80104890 <sys_open+0xb5>
    if(f)
80104906:	85 db                	test   %ebx,%ebx
80104908:	74 0c                	je     80104916 <sys_open+0x13b>
      fileclose(f);
8010490a:	83 ec 0c             	sub    $0xc,%esp
8010490d:	53                   	push   %ebx
8010490e:	e8 b0 c3 ff ff       	call   80100cc3 <fileclose>
80104913:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104916:	83 ec 0c             	sub    $0xc,%esp
80104919:	56                   	push   %esi
8010491a:	e8 f7 cd ff ff       	call   80101716 <iunlockput>
    end_op();
8010491f:	e8 d4 de ff ff       	call   801027f8 <end_op>
    return -1;
80104924:	83 c4 10             	add    $0x10,%esp
80104927:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010492c:	e9 5f ff ff ff       	jmp    80104890 <sys_open+0xb5>

80104931 <sys_mkdir>:

int
sys_mkdir(void)
{
80104931:	55                   	push   %ebp
80104932:	89 e5                	mov    %esp,%ebp
80104934:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104937:	e8 42 de ff ff       	call   8010277e <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010493c:	83 ec 08             	sub    $0x8,%esp
8010493f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104942:	50                   	push   %eax
80104943:	6a 00                	push   $0x0
80104945:	e8 03 f7 ff ff       	call   8010404d <argstr>
8010494a:	83 c4 10             	add    $0x10,%esp
8010494d:	85 c0                	test   %eax,%eax
8010494f:	78 36                	js     80104987 <sys_mkdir+0x56>
80104951:	83 ec 0c             	sub    $0xc,%esp
80104954:	6a 00                	push   $0x0
80104956:	b9 00 00 00 00       	mov    $0x0,%ecx
8010495b:	ba 01 00 00 00       	mov    $0x1,%edx
80104960:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104963:	e8 5c f8 ff ff       	call   801041c4 <create>
80104968:	83 c4 10             	add    $0x10,%esp
8010496b:	85 c0                	test   %eax,%eax
8010496d:	74 18                	je     80104987 <sys_mkdir+0x56>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010496f:	83 ec 0c             	sub    $0xc,%esp
80104972:	50                   	push   %eax
80104973:	e8 9e cd ff ff       	call   80101716 <iunlockput>
  end_op();
80104978:	e8 7b de ff ff       	call   801027f8 <end_op>
  return 0;
8010497d:	83 c4 10             	add    $0x10,%esp
80104980:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104985:	c9                   	leave  
80104986:	c3                   	ret    
    end_op();
80104987:	e8 6c de ff ff       	call   801027f8 <end_op>
    return -1;
8010498c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104991:	eb f2                	jmp    80104985 <sys_mkdir+0x54>

80104993 <sys_mknod>:

int
sys_mknod(void)
{
80104993:	55                   	push   %ebp
80104994:	89 e5                	mov    %esp,%ebp
80104996:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104999:	e8 e0 dd ff ff       	call   8010277e <begin_op>
  if((argstr(0, &path)) < 0 ||
8010499e:	83 ec 08             	sub    $0x8,%esp
801049a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049a4:	50                   	push   %eax
801049a5:	6a 00                	push   $0x0
801049a7:	e8 a1 f6 ff ff       	call   8010404d <argstr>
801049ac:	83 c4 10             	add    $0x10,%esp
801049af:	85 c0                	test   %eax,%eax
801049b1:	78 62                	js     80104a15 <sys_mknod+0x82>
     argint(1, &major) < 0 ||
801049b3:	83 ec 08             	sub    $0x8,%esp
801049b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049b9:	50                   	push   %eax
801049ba:	6a 01                	push   $0x1
801049bc:	e8 fc f5 ff ff       	call   80103fbd <argint>
  if((argstr(0, &path)) < 0 ||
801049c1:	83 c4 10             	add    $0x10,%esp
801049c4:	85 c0                	test   %eax,%eax
801049c6:	78 4d                	js     80104a15 <sys_mknod+0x82>
     argint(2, &minor) < 0 ||
801049c8:	83 ec 08             	sub    $0x8,%esp
801049cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801049ce:	50                   	push   %eax
801049cf:	6a 02                	push   $0x2
801049d1:	e8 e7 f5 ff ff       	call   80103fbd <argint>
     argint(1, &major) < 0 ||
801049d6:	83 c4 10             	add    $0x10,%esp
801049d9:	85 c0                	test   %eax,%eax
801049db:	78 38                	js     80104a15 <sys_mknod+0x82>
     (ip = create(path, T_DEV, major, minor)) == 0){
801049dd:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801049e1:	83 ec 0c             	sub    $0xc,%esp
801049e4:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
801049e8:	50                   	push   %eax
801049e9:	ba 03 00 00 00       	mov    $0x3,%edx
801049ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f1:	e8 ce f7 ff ff       	call   801041c4 <create>
     argint(2, &minor) < 0 ||
801049f6:	83 c4 10             	add    $0x10,%esp
801049f9:	85 c0                	test   %eax,%eax
801049fb:	74 18                	je     80104a15 <sys_mknod+0x82>
    end_op();
    return -1;
  }
  iunlockput(ip);
801049fd:	83 ec 0c             	sub    $0xc,%esp
80104a00:	50                   	push   %eax
80104a01:	e8 10 cd ff ff       	call   80101716 <iunlockput>
  end_op();
80104a06:	e8 ed dd ff ff       	call   801027f8 <end_op>
  return 0;
80104a0b:	83 c4 10             	add    $0x10,%esp
80104a0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a13:	c9                   	leave  
80104a14:	c3                   	ret    
    end_op();
80104a15:	e8 de dd ff ff       	call   801027f8 <end_op>
    return -1;
80104a1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a1f:	eb f2                	jmp    80104a13 <sys_mknod+0x80>

80104a21 <sys_chdir>:

int
sys_chdir(void)
{
80104a21:	55                   	push   %ebp
80104a22:	89 e5                	mov    %esp,%ebp
80104a24:	56                   	push   %esi
80104a25:	53                   	push   %ebx
80104a26:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104a29:	e8 94 e7 ff ff       	call   801031c2 <myproc>
80104a2e:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104a30:	e8 49 dd ff ff       	call   8010277e <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104a35:	83 ec 08             	sub    $0x8,%esp
80104a38:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a3b:	50                   	push   %eax
80104a3c:	6a 00                	push   $0x0
80104a3e:	e8 0a f6 ff ff       	call   8010404d <argstr>
80104a43:	83 c4 10             	add    $0x10,%esp
80104a46:	85 c0                	test   %eax,%eax
80104a48:	78 52                	js     80104a9c <sys_chdir+0x7b>
80104a4a:	83 ec 0c             	sub    $0xc,%esp
80104a4d:	ff 75 f4             	push   -0xc(%ebp)
80104a50:	e8 78 d1 ff ff       	call   80101bcd <namei>
80104a55:	89 c3                	mov    %eax,%ebx
80104a57:	83 c4 10             	add    $0x10,%esp
80104a5a:	85 c0                	test   %eax,%eax
80104a5c:	74 3e                	je     80104a9c <sys_chdir+0x7b>
    end_op();
    return -1;
  }
  ilock(ip);
80104a5e:	83 ec 0c             	sub    $0xc,%esp
80104a61:	50                   	push   %eax
80104a62:	e8 08 cb ff ff       	call   8010156f <ilock>
  if(ip->type != T_DIR){
80104a67:	83 c4 10             	add    $0x10,%esp
80104a6a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104a6f:	75 37                	jne    80104aa8 <sys_chdir+0x87>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104a71:	83 ec 0c             	sub    $0xc,%esp
80104a74:	53                   	push   %ebx
80104a75:	e8 b7 cb ff ff       	call   80101631 <iunlock>
  iput(curproc->cwd);
80104a7a:	83 c4 04             	add    $0x4,%esp
80104a7d:	ff 76 68             	push   0x68(%esi)
80104a80:	e8 f1 cb ff ff       	call   80101676 <iput>
  end_op();
80104a85:	e8 6e dd ff ff       	call   801027f8 <end_op>
  curproc->cwd = ip;
80104a8a:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104a8d:	83 c4 10             	add    $0x10,%esp
80104a90:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a98:	5b                   	pop    %ebx
80104a99:	5e                   	pop    %esi
80104a9a:	5d                   	pop    %ebp
80104a9b:	c3                   	ret    
    end_op();
80104a9c:	e8 57 dd ff ff       	call   801027f8 <end_op>
    return -1;
80104aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aa6:	eb ed                	jmp    80104a95 <sys_chdir+0x74>
    iunlockput(ip);
80104aa8:	83 ec 0c             	sub    $0xc,%esp
80104aab:	53                   	push   %ebx
80104aac:	e8 65 cc ff ff       	call   80101716 <iunlockput>
    end_op();
80104ab1:	e8 42 dd ff ff       	call   801027f8 <end_op>
    return -1;
80104ab6:	83 c4 10             	add    $0x10,%esp
80104ab9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104abe:	eb d5                	jmp    80104a95 <sys_chdir+0x74>

80104ac0 <sys_exec>:

int
sys_exec(void)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	53                   	push   %ebx
80104ac4:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104aca:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104acd:	50                   	push   %eax
80104ace:	6a 00                	push   $0x0
80104ad0:	e8 78 f5 ff ff       	call   8010404d <argstr>
80104ad5:	83 c4 10             	add    $0x10,%esp
80104ad8:	85 c0                	test   %eax,%eax
80104ada:	78 38                	js     80104b14 <sys_exec+0x54>
80104adc:	83 ec 08             	sub    $0x8,%esp
80104adf:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104ae5:	50                   	push   %eax
80104ae6:	6a 01                	push   $0x1
80104ae8:	e8 d0 f4 ff ff       	call   80103fbd <argint>
80104aed:	83 c4 10             	add    $0x10,%esp
80104af0:	85 c0                	test   %eax,%eax
80104af2:	78 20                	js     80104b14 <sys_exec+0x54>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104af4:	83 ec 04             	sub    $0x4,%esp
80104af7:	68 80 00 00 00       	push   $0x80
80104afc:	6a 00                	push   $0x0
80104afe:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104b04:	50                   	push   %eax
80104b05:	e8 63 f2 ff ff       	call   80103d6d <memset>
80104b0a:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104b0d:	bb 00 00 00 00       	mov    $0x0,%ebx
80104b12:	eb 2c                	jmp    80104b40 <sys_exec+0x80>
    return -1;
80104b14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b19:	eb 78                	jmp    80104b93 <sys_exec+0xd3>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80104b1b:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104b22:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104b26:	83 ec 08             	sub    $0x8,%esp
80104b29:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104b2f:	50                   	push   %eax
80104b30:	ff 75 f4             	push   -0xc(%ebp)
80104b33:	e8 96 bd ff ff       	call   801008ce <exec>
80104b38:	83 c4 10             	add    $0x10,%esp
80104b3b:	eb 56                	jmp    80104b93 <sys_exec+0xd3>
  for(i=0;; i++){
80104b3d:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80104b40:	83 fb 1f             	cmp    $0x1f,%ebx
80104b43:	77 49                	ja     80104b8e <sys_exec+0xce>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104b45:	83 ec 08             	sub    $0x8,%esp
80104b48:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104b4e:	50                   	push   %eax
80104b4f:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104b55:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104b58:	50                   	push   %eax
80104b59:	e8 e5 f3 ff ff       	call   80103f43 <fetchint>
80104b5e:	83 c4 10             	add    $0x10,%esp
80104b61:	85 c0                	test   %eax,%eax
80104b63:	78 33                	js     80104b98 <sys_exec+0xd8>
    if(uarg == 0){
80104b65:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104b6b:	85 c0                	test   %eax,%eax
80104b6d:	74 ac                	je     80104b1b <sys_exec+0x5b>
    if(fetchstr(uarg, &argv[i]) < 0)
80104b6f:	83 ec 08             	sub    $0x8,%esp
80104b72:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104b79:	52                   	push   %edx
80104b7a:	50                   	push   %eax
80104b7b:	e8 fe f3 ff ff       	call   80103f7e <fetchstr>
80104b80:	83 c4 10             	add    $0x10,%esp
80104b83:	85 c0                	test   %eax,%eax
80104b85:	79 b6                	jns    80104b3d <sys_exec+0x7d>
      return -1;
80104b87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b8c:	eb 05                	jmp    80104b93 <sys_exec+0xd3>
      return -1;
80104b8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b96:	c9                   	leave  
80104b97:	c3                   	ret    
      return -1;
80104b98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b9d:	eb f4                	jmp    80104b93 <sys_exec+0xd3>

80104b9f <sys_pipe>:

int
sys_pipe(void)
{
80104b9f:	55                   	push   %ebp
80104ba0:	89 e5                	mov    %esp,%ebp
80104ba2:	53                   	push   %ebx
80104ba3:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104ba6:	6a 08                	push   $0x8
80104ba8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bab:	50                   	push   %eax
80104bac:	6a 00                	push   $0x0
80104bae:	e8 32 f4 ff ff       	call   80103fe5 <argptr>
80104bb3:	83 c4 10             	add    $0x10,%esp
80104bb6:	85 c0                	test   %eax,%eax
80104bb8:	78 79                	js     80104c33 <sys_pipe+0x94>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104bba:	83 ec 08             	sub    $0x8,%esp
80104bbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104bc0:	50                   	push   %eax
80104bc1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bc4:	50                   	push   %eax
80104bc5:	e8 3d e1 ff ff       	call   80102d07 <pipealloc>
80104bca:	83 c4 10             	add    $0x10,%esp
80104bcd:	85 c0                	test   %eax,%eax
80104bcf:	78 69                	js     80104c3a <sys_pipe+0x9b>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bd4:	e8 5e f5 ff ff       	call   80104137 <fdalloc>
80104bd9:	89 c3                	mov    %eax,%ebx
80104bdb:	85 c0                	test   %eax,%eax
80104bdd:	78 21                	js     80104c00 <sys_pipe+0x61>
80104bdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104be2:	e8 50 f5 ff ff       	call   80104137 <fdalloc>
80104be7:	85 c0                	test   %eax,%eax
80104be9:	78 15                	js     80104c00 <sys_pipe+0x61>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104beb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bee:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104bf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bf3:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104bf6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104bfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bfe:	c9                   	leave  
80104bff:	c3                   	ret    
    if(fd0 >= 0)
80104c00:	85 db                	test   %ebx,%ebx
80104c02:	79 20                	jns    80104c24 <sys_pipe+0x85>
    fileclose(rf);
80104c04:	83 ec 0c             	sub    $0xc,%esp
80104c07:	ff 75 f0             	push   -0x10(%ebp)
80104c0a:	e8 b4 c0 ff ff       	call   80100cc3 <fileclose>
    fileclose(wf);
80104c0f:	83 c4 04             	add    $0x4,%esp
80104c12:	ff 75 ec             	push   -0x14(%ebp)
80104c15:	e8 a9 c0 ff ff       	call   80100cc3 <fileclose>
    return -1;
80104c1a:	83 c4 10             	add    $0x10,%esp
80104c1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c22:	eb d7                	jmp    80104bfb <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
80104c24:	e8 99 e5 ff ff       	call   801031c2 <myproc>
80104c29:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104c30:	00 
80104c31:	eb d1                	jmp    80104c04 <sys_pipe+0x65>
    return -1;
80104c33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c38:	eb c1                	jmp    80104bfb <sys_pipe+0x5c>
    return -1;
80104c3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c3f:	eb ba                	jmp    80104bfb <sys_pipe+0x5c>

80104c41 <sys_fork>:
#include "proc.h"
#include "pstat.h"

int
sys_fork(void)
{
80104c41:	55                   	push   %ebp
80104c42:	89 e5                	mov    %esp,%ebp
80104c44:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104c47:	e8 ec e6 ff ff       	call   80103338 <fork>
}
80104c4c:	c9                   	leave  
80104c4d:	c3                   	ret    

80104c4e <sys_exit>:

int
sys_exit(void)
{
80104c4e:	55                   	push   %ebp
80104c4f:	89 e5                	mov    %esp,%ebp
80104c51:	83 ec 08             	sub    $0x8,%esp
  exit();
80104c54:	e8 ba e9 ff ff       	call   80103613 <exit>
  return 0;  // not reached
}
80104c59:	b8 00 00 00 00       	mov    $0x0,%eax
80104c5e:	c9                   	leave  
80104c5f:	c3                   	ret    

80104c60 <sys_wait>:

int
sys_wait(void)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	83 ec 08             	sub    $0x8,%esp
  return wait();
80104c66:	e8 34 eb ff ff       	call   8010379f <wait>
}
80104c6b:	c9                   	leave  
80104c6c:	c3                   	ret    

80104c6d <sys_kill>:

int
sys_kill(void)
{
80104c6d:	55                   	push   %ebp
80104c6e:	89 e5                	mov    %esp,%ebp
80104c70:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104c73:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c76:	50                   	push   %eax
80104c77:	6a 00                	push   $0x0
80104c79:	e8 3f f3 ff ff       	call   80103fbd <argint>
80104c7e:	83 c4 10             	add    $0x10,%esp
80104c81:	85 c0                	test   %eax,%eax
80104c83:	78 10                	js     80104c95 <sys_kill+0x28>
    return -1;
  return kill(pid);
80104c85:	83 ec 0c             	sub    $0xc,%esp
80104c88:	ff 75 f4             	push   -0xc(%ebp)
80104c8b:	e8 0f ec ff ff       	call   8010389f <kill>
80104c90:	83 c4 10             	add    $0x10,%esp
}
80104c93:	c9                   	leave  
80104c94:	c3                   	ret    
    return -1;
80104c95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c9a:	eb f7                	jmp    80104c93 <sys_kill+0x26>

80104c9c <sys_getpid>:

int
sys_getpid(void)
{
80104c9c:	55                   	push   %ebp
80104c9d:	89 e5                	mov    %esp,%ebp
80104c9f:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104ca2:	e8 1b e5 ff ff       	call   801031c2 <myproc>
80104ca7:	8b 40 10             	mov    0x10(%eax),%eax
}
80104caa:	c9                   	leave  
80104cab:	c3                   	ret    

80104cac <sys_sbrk>:

int
sys_sbrk(void)
{
80104cac:	55                   	push   %ebp
80104cad:	89 e5                	mov    %esp,%ebp
80104caf:	53                   	push   %ebx
80104cb0:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104cb3:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cb6:	50                   	push   %eax
80104cb7:	6a 00                	push   $0x0
80104cb9:	e8 ff f2 ff ff       	call   80103fbd <argint>
80104cbe:	83 c4 10             	add    $0x10,%esp
80104cc1:	85 c0                	test   %eax,%eax
80104cc3:	78 20                	js     80104ce5 <sys_sbrk+0x39>
    return -1;
  addr = myproc()->sz;
80104cc5:	e8 f8 e4 ff ff       	call   801031c2 <myproc>
80104cca:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80104ccc:	83 ec 0c             	sub    $0xc,%esp
80104ccf:	ff 75 f4             	push   -0xc(%ebp)
80104cd2:	e8 f6 e5 ff ff       	call   801032cd <growproc>
80104cd7:	83 c4 10             	add    $0x10,%esp
80104cda:	85 c0                	test   %eax,%eax
80104cdc:	78 0e                	js     80104cec <sys_sbrk+0x40>
    return -1;
  return addr;
}
80104cde:	89 d8                	mov    %ebx,%eax
80104ce0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ce3:	c9                   	leave  
80104ce4:	c3                   	ret    
    return -1;
80104ce5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104cea:	eb f2                	jmp    80104cde <sys_sbrk+0x32>
    return -1;
80104cec:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104cf1:	eb eb                	jmp    80104cde <sys_sbrk+0x32>

80104cf3 <sys_sleep>:

int
sys_sleep(void)
{
80104cf3:	55                   	push   %ebp
80104cf4:	89 e5                	mov    %esp,%ebp
80104cf6:	53                   	push   %ebx
80104cf7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104cfa:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cfd:	50                   	push   %eax
80104cfe:	6a 00                	push   $0x0
80104d00:	e8 b8 f2 ff ff       	call   80103fbd <argint>
80104d05:	83 c4 10             	add    $0x10,%esp
80104d08:	85 c0                	test   %eax,%eax
80104d0a:	78 75                	js     80104d81 <sys_sleep+0x8e>
    return -1;
  acquire(&tickslock);
80104d0c:	83 ec 0c             	sub    $0xc,%esp
80104d0f:	68 80 3e 11 80       	push   $0x80113e80
80104d14:	e8 a8 ef ff ff       	call   80103cc1 <acquire>
  ticks0 = ticks;
80104d19:	8b 1d 60 3e 11 80    	mov    0x80113e60,%ebx
  while(ticks - ticks0 < n){
80104d1f:	83 c4 10             	add    $0x10,%esp
80104d22:	a1 60 3e 11 80       	mov    0x80113e60,%eax
80104d27:	29 d8                	sub    %ebx,%eax
80104d29:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104d2c:	73 39                	jae    80104d67 <sys_sleep+0x74>
    if(myproc()->killed){
80104d2e:	e8 8f e4 ff ff       	call   801031c2 <myproc>
80104d33:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104d37:	75 17                	jne    80104d50 <sys_sleep+0x5d>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104d39:	83 ec 08             	sub    $0x8,%esp
80104d3c:	68 80 3e 11 80       	push   $0x80113e80
80104d41:	68 60 3e 11 80       	push   $0x80113e60
80104d46:	e8 c3 e9 ff ff       	call   8010370e <sleep>
80104d4b:	83 c4 10             	add    $0x10,%esp
80104d4e:	eb d2                	jmp    80104d22 <sys_sleep+0x2f>
      release(&tickslock);
80104d50:	83 ec 0c             	sub    $0xc,%esp
80104d53:	68 80 3e 11 80       	push   $0x80113e80
80104d58:	e8 c9 ef ff ff       	call   80103d26 <release>
      return -1;
80104d5d:	83 c4 10             	add    $0x10,%esp
80104d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d65:	eb 15                	jmp    80104d7c <sys_sleep+0x89>
  }
  release(&tickslock);
80104d67:	83 ec 0c             	sub    $0xc,%esp
80104d6a:	68 80 3e 11 80       	push   $0x80113e80
80104d6f:	e8 b2 ef ff ff       	call   80103d26 <release>
  return 0;
80104d74:	83 c4 10             	add    $0x10,%esp
80104d77:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d7f:	c9                   	leave  
80104d80:	c3                   	ret    
    return -1;
80104d81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d86:	eb f4                	jmp    80104d7c <sys_sleep+0x89>

80104d88 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104d88:	55                   	push   %ebp
80104d89:	89 e5                	mov    %esp,%ebp
80104d8b:	53                   	push   %ebx
80104d8c:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104d8f:	68 80 3e 11 80       	push   $0x80113e80
80104d94:	e8 28 ef ff ff       	call   80103cc1 <acquire>
  xticks = ticks;
80104d99:	8b 1d 60 3e 11 80    	mov    0x80113e60,%ebx
  release(&tickslock);
80104d9f:	c7 04 24 80 3e 11 80 	movl   $0x80113e80,(%esp)
80104da6:	e8 7b ef ff ff       	call   80103d26 <release>
  return xticks;
}
80104dab:	89 d8                	mov    %ebx,%eax
80104dad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104db0:	c9                   	leave  
80104db1:	c3                   	ret    

80104db2 <sys_settickets>:

// set the number of tickets of the calling process.
int
sys_settickets(void)
{
80104db2:	55                   	push   %ebp
80104db3:	89 e5                	mov    %esp,%ebp
80104db5:	83 ec 20             	sub    $0x20,%esp
  int numtickets;

  if(argint(0, &numtickets) < 0)
80104db8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dbb:	50                   	push   %eax
80104dbc:	6a 00                	push   $0x0
80104dbe:	e8 fa f1 ff ff       	call   80103fbd <argint>
80104dc3:	83 c4 10             	add    $0x10,%esp
80104dc6:	85 c0                	test   %eax,%eax
80104dc8:	78 10                	js     80104dda <sys_settickets+0x28>
    return -1;
  
  return settickets(numtickets);
80104dca:	83 ec 0c             	sub    $0xc,%esp
80104dcd:	ff 75 f4             	push   -0xc(%ebp)
80104dd0:	e8 f5 eb ff ff       	call   801039ca <settickets>
80104dd5:	83 c4 10             	add    $0x10,%esp
}
80104dd8:	c9                   	leave  
80104dd9:	c3                   	ret    
    return -1;
80104dda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ddf:	eb f7                	jmp    80104dd8 <sys_settickets+0x26>

80104de1 <sys_getpinfo>:

// return information about all running processes
int
sys_getpinfo(void)
{
80104de1:	55                   	push   %ebp
80104de2:	89 e5                	mov    %esp,%ebp
80104de4:	83 ec 1c             	sub    $0x1c,%esp
  struct pstat *pstat;

  if(argptr(0, (void*)&pstat, sizeof(*pstat)) < 0)
80104de7:	68 00 04 00 00       	push   $0x400
80104dec:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104def:	50                   	push   %eax
80104df0:	6a 00                	push   $0x0
80104df2:	e8 ee f1 ff ff       	call   80103fe5 <argptr>
80104df7:	83 c4 10             	add    $0x10,%esp
80104dfa:	85 c0                	test   %eax,%eax
80104dfc:	78 10                	js     80104e0e <sys_getpinfo+0x2d>
    return -1;
    
  return getpinfo(pstat);
80104dfe:	83 ec 0c             	sub    $0xc,%esp
80104e01:	ff 75 f4             	push   -0xc(%ebp)
80104e04:	e8 e9 eb ff ff       	call   801039f2 <getpinfo>
80104e09:	83 c4 10             	add    $0x10,%esp
}
80104e0c:	c9                   	leave  
80104e0d:	c3                   	ret    
    return -1;
80104e0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e13:	eb f7                	jmp    80104e0c <sys_getpinfo+0x2b>

80104e15 <sys_mprotect>:

int
sys_mprotect(void) {
  return 0;
}
80104e15:	b8 00 00 00 00       	mov    $0x0,%eax
80104e1a:	c3                   	ret    

80104e1b <sys_munprotect>:

int
sys_munprotect(void) {
  return 0;
80104e1b:	b8 00 00 00 00       	mov    $0x0,%eax
80104e20:	c3                   	ret    

80104e21 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104e21:	1e                   	push   %ds
  pushl %es
80104e22:	06                   	push   %es
  pushl %fs
80104e23:	0f a0                	push   %fs
  pushl %gs
80104e25:	0f a8                	push   %gs
  pushal
80104e27:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104e28:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104e2c:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104e2e:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104e30:	54                   	push   %esp
  call trap
80104e31:	e8 37 01 00 00       	call   80104f6d <trap>
  addl $4, %esp
80104e36:	83 c4 04             	add    $0x4,%esp

80104e39 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80104e39:	61                   	popa   
  popl %gs
80104e3a:	0f a9                	pop    %gs
  popl %fs
80104e3c:	0f a1                	pop    %fs
  popl %es
80104e3e:	07                   	pop    %es
  popl %ds
80104e3f:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80104e40:	83 c4 08             	add    $0x8,%esp
  iret
80104e43:	cf                   	iret   

80104e44 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80104e44:	55                   	push   %ebp
80104e45:	89 e5                	mov    %esp,%ebp
80104e47:	53                   	push   %ebx
80104e48:	83 ec 04             	sub    $0x4,%esp
  int i;

  for(i = 0; i < 256; i++)
80104e4b:	b8 00 00 00 00       	mov    $0x0,%eax
80104e50:	eb 76                	jmp    80104ec8 <tvinit+0x84>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104e52:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
80104e59:	66 89 0c c5 c0 3e 11 	mov    %cx,-0x7feec140(,%eax,8)
80104e60:	80 
80104e61:	66 c7 04 c5 c2 3e 11 	movw   $0x8,-0x7feec13e(,%eax,8)
80104e68:	80 08 00 
80104e6b:	0f b6 14 c5 c4 3e 11 	movzbl -0x7feec13c(,%eax,8),%edx
80104e72:	80 
80104e73:	83 e2 e0             	and    $0xffffffe0,%edx
80104e76:	88 14 c5 c4 3e 11 80 	mov    %dl,-0x7feec13c(,%eax,8)
80104e7d:	c6 04 c5 c4 3e 11 80 	movb   $0x0,-0x7feec13c(,%eax,8)
80104e84:	00 
80104e85:	0f b6 14 c5 c5 3e 11 	movzbl -0x7feec13b(,%eax,8),%edx
80104e8c:	80 
80104e8d:	83 e2 f0             	and    $0xfffffff0,%edx
80104e90:	83 ca 0e             	or     $0xe,%edx
80104e93:	88 14 c5 c5 3e 11 80 	mov    %dl,-0x7feec13b(,%eax,8)
80104e9a:	89 d3                	mov    %edx,%ebx
80104e9c:	83 e3 ef             	and    $0xffffffef,%ebx
80104e9f:	88 1c c5 c5 3e 11 80 	mov    %bl,-0x7feec13b(,%eax,8)
80104ea6:	83 e2 8f             	and    $0xffffff8f,%edx
80104ea9:	88 14 c5 c5 3e 11 80 	mov    %dl,-0x7feec13b(,%eax,8)
80104eb0:	83 ca 80             	or     $0xffffff80,%edx
80104eb3:	88 14 c5 c5 3e 11 80 	mov    %dl,-0x7feec13b(,%eax,8)
80104eba:	c1 e9 10             	shr    $0x10,%ecx
80104ebd:	66 89 0c c5 c6 3e 11 	mov    %cx,-0x7feec13a(,%eax,8)
80104ec4:	80 
  for(i = 0; i < 256; i++)
80104ec5:	83 c0 01             	add    $0x1,%eax
80104ec8:	3d ff 00 00 00       	cmp    $0xff,%eax
80104ecd:	7e 83                	jle    80104e52 <tvinit+0xe>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104ecf:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
80104ed5:	66 89 15 c0 40 11 80 	mov    %dx,0x801140c0
80104edc:	66 c7 05 c2 40 11 80 	movw   $0x8,0x801140c2
80104ee3:	08 00 
80104ee5:	0f b6 05 c4 40 11 80 	movzbl 0x801140c4,%eax
80104eec:	83 e0 e0             	and    $0xffffffe0,%eax
80104eef:	a2 c4 40 11 80       	mov    %al,0x801140c4
80104ef4:	c6 05 c4 40 11 80 00 	movb   $0x0,0x801140c4
80104efb:	0f b6 05 c5 40 11 80 	movzbl 0x801140c5,%eax
80104f02:	83 c8 0f             	or     $0xf,%eax
80104f05:	a2 c5 40 11 80       	mov    %al,0x801140c5
80104f0a:	83 e0 ef             	and    $0xffffffef,%eax
80104f0d:	a2 c5 40 11 80       	mov    %al,0x801140c5
80104f12:	89 c1                	mov    %eax,%ecx
80104f14:	83 c9 60             	or     $0x60,%ecx
80104f17:	88 0d c5 40 11 80    	mov    %cl,0x801140c5
80104f1d:	83 c8 e0             	or     $0xffffffe0,%eax
80104f20:	a2 c5 40 11 80       	mov    %al,0x801140c5
80104f25:	c1 ea 10             	shr    $0x10,%edx
80104f28:	66 89 15 c6 40 11 80 	mov    %dx,0x801140c6

  initlock(&tickslock, "time");
80104f2f:	83 ec 08             	sub    $0x8,%esp
80104f32:	68 a9 6e 10 80       	push   $0x80106ea9
80104f37:	68 80 3e 11 80       	push   $0x80113e80
80104f3c:	e8 44 ec ff ff       	call   80103b85 <initlock>
}
80104f41:	83 c4 10             	add    $0x10,%esp
80104f44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f47:	c9                   	leave  
80104f48:	c3                   	ret    

80104f49 <idtinit>:

void
idtinit(void)
{
80104f49:	55                   	push   %ebp
80104f4a:	89 e5                	mov    %esp,%ebp
80104f4c:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104f4f:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104f55:	b8 c0 3e 11 80       	mov    $0x80113ec0,%eax
80104f5a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80104f5e:	c1 e8 10             	shr    $0x10,%eax
80104f61:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80104f65:	8d 45 fa             	lea    -0x6(%ebp),%eax
80104f68:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80104f6b:	c9                   	leave  
80104f6c:	c3                   	ret    

80104f6d <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80104f6d:	55                   	push   %ebp
80104f6e:	89 e5                	mov    %esp,%ebp
80104f70:	57                   	push   %edi
80104f71:	56                   	push   %esi
80104f72:	53                   	push   %ebx
80104f73:	83 ec 1c             	sub    $0x1c,%esp
80104f76:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80104f79:	8b 43 30             	mov    0x30(%ebx),%eax
80104f7c:	83 f8 40             	cmp    $0x40,%eax
80104f7f:	74 13                	je     80104f94 <trap+0x27>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80104f81:	83 e8 20             	sub    $0x20,%eax
80104f84:	83 f8 1f             	cmp    $0x1f,%eax
80104f87:	0f 87 3a 01 00 00    	ja     801050c7 <trap+0x15a>
80104f8d:	ff 24 85 50 6f 10 80 	jmp    *-0x7fef90b0(,%eax,4)
    if(myproc()->killed)
80104f94:	e8 29 e2 ff ff       	call   801031c2 <myproc>
80104f99:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104f9d:	75 1f                	jne    80104fbe <trap+0x51>
    myproc()->tf = tf;
80104f9f:	e8 1e e2 ff ff       	call   801031c2 <myproc>
80104fa4:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80104fa7:	e8 d4 f0 ff ff       	call   80104080 <syscall>
    if(myproc()->killed)
80104fac:	e8 11 e2 ff ff       	call   801031c2 <myproc>
80104fb1:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104fb5:	74 7e                	je     80105035 <trap+0xc8>
      exit();
80104fb7:	e8 57 e6 ff ff       	call   80103613 <exit>
    return;
80104fbc:	eb 77                	jmp    80105035 <trap+0xc8>
      exit();
80104fbe:	e8 50 e6 ff ff       	call   80103613 <exit>
80104fc3:	eb da                	jmp    80104f9f <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80104fc5:	e8 dd e1 ff ff       	call   801031a7 <cpuid>
80104fca:	85 c0                	test   %eax,%eax
80104fcc:	74 6f                	je     8010503d <trap+0xd0>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80104fce:	e8 a3 d3 ff ff       	call   80102376 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104fd3:	e8 ea e1 ff ff       	call   801031c2 <myproc>
80104fd8:	85 c0                	test   %eax,%eax
80104fda:	74 1c                	je     80104ff8 <trap+0x8b>
80104fdc:	e8 e1 e1 ff ff       	call   801031c2 <myproc>
80104fe1:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104fe5:	74 11                	je     80104ff8 <trap+0x8b>
80104fe7:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80104feb:	83 e0 03             	and    $0x3,%eax
80104fee:	66 83 f8 03          	cmp    $0x3,%ax
80104ff2:	0f 84 62 01 00 00    	je     8010515a <trap+0x1ed>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80104ff8:	e8 c5 e1 ff ff       	call   801031c2 <myproc>
80104ffd:	85 c0                	test   %eax,%eax
80104fff:	74 0f                	je     80105010 <trap+0xa3>
80105001:	e8 bc e1 ff ff       	call   801031c2 <myproc>
80105006:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010500a:	0f 84 54 01 00 00    	je     80105164 <trap+0x1f7>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105010:	e8 ad e1 ff ff       	call   801031c2 <myproc>
80105015:	85 c0                	test   %eax,%eax
80105017:	74 1c                	je     80105035 <trap+0xc8>
80105019:	e8 a4 e1 ff ff       	call   801031c2 <myproc>
8010501e:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105022:	74 11                	je     80105035 <trap+0xc8>
80105024:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105028:	83 e0 03             	and    $0x3,%eax
8010502b:	66 83 f8 03          	cmp    $0x3,%ax
8010502f:	0f 84 43 01 00 00    	je     80105178 <trap+0x20b>
    exit();
}
80105035:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105038:	5b                   	pop    %ebx
80105039:	5e                   	pop    %esi
8010503a:	5f                   	pop    %edi
8010503b:	5d                   	pop    %ebp
8010503c:	c3                   	ret    
      acquire(&tickslock);
8010503d:	83 ec 0c             	sub    $0xc,%esp
80105040:	68 80 3e 11 80       	push   $0x80113e80
80105045:	e8 77 ec ff ff       	call   80103cc1 <acquire>
      ticks++;
8010504a:	83 05 60 3e 11 80 01 	addl   $0x1,0x80113e60
      wakeup(&ticks);
80105051:	c7 04 24 60 3e 11 80 	movl   $0x80113e60,(%esp)
80105058:	e8 19 e8 ff ff       	call   80103876 <wakeup>
      release(&tickslock);
8010505d:	c7 04 24 80 3e 11 80 	movl   $0x80113e80,(%esp)
80105064:	e8 bd ec ff ff       	call   80103d26 <release>
80105069:	83 c4 10             	add    $0x10,%esp
8010506c:	e9 5d ff ff ff       	jmp    80104fce <trap+0x61>
    ideintr();
80105071:	e8 e6 cc ff ff       	call   80101d5c <ideintr>
    lapiceoi();
80105076:	e8 fb d2 ff ff       	call   80102376 <lapiceoi>
    break;
8010507b:	e9 53 ff ff ff       	jmp    80104fd3 <trap+0x66>
    kbdintr();
80105080:	e8 3b d1 ff ff       	call   801021c0 <kbdintr>
    lapiceoi();
80105085:	e8 ec d2 ff ff       	call   80102376 <lapiceoi>
    break;
8010508a:	e9 44 ff ff ff       	jmp    80104fd3 <trap+0x66>
    uartintr();
8010508f:	e8 fe 01 00 00       	call   80105292 <uartintr>
    lapiceoi();
80105094:	e8 dd d2 ff ff       	call   80102376 <lapiceoi>
    break;
80105099:	e9 35 ff ff ff       	jmp    80104fd3 <trap+0x66>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010509e:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
801050a1:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801050a5:	e8 fd e0 ff ff       	call   801031a7 <cpuid>
801050aa:	57                   	push   %edi
801050ab:	0f b7 f6             	movzwl %si,%esi
801050ae:	56                   	push   %esi
801050af:	50                   	push   %eax
801050b0:	68 b4 6e 10 80       	push   $0x80106eb4
801050b5:	e8 4d b5 ff ff       	call   80100607 <cprintf>
    lapiceoi();
801050ba:	e8 b7 d2 ff ff       	call   80102376 <lapiceoi>
    break;
801050bf:	83 c4 10             	add    $0x10,%esp
801050c2:	e9 0c ff ff ff       	jmp    80104fd3 <trap+0x66>
    if(myproc() == 0 || (tf->cs&3) == 0){
801050c7:	e8 f6 e0 ff ff       	call   801031c2 <myproc>
801050cc:	85 c0                	test   %eax,%eax
801050ce:	74 5f                	je     8010512f <trap+0x1c2>
801050d0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801050d4:	74 59                	je     8010512f <trap+0x1c2>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801050d6:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801050d9:	8b 43 38             	mov    0x38(%ebx),%eax
801050dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801050df:	e8 c3 e0 ff ff       	call   801031a7 <cpuid>
801050e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801050e7:	8b 53 34             	mov    0x34(%ebx),%edx
801050ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
801050ed:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
801050f0:	e8 cd e0 ff ff       	call   801031c2 <myproc>
801050f5:	8d 48 6c             	lea    0x6c(%eax),%ecx
801050f8:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801050fb:	e8 c2 e0 ff ff       	call   801031c2 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105100:	57                   	push   %edi
80105101:	ff 75 e4             	push   -0x1c(%ebp)
80105104:	ff 75 e0             	push   -0x20(%ebp)
80105107:	ff 75 dc             	push   -0x24(%ebp)
8010510a:	56                   	push   %esi
8010510b:	ff 75 d8             	push   -0x28(%ebp)
8010510e:	ff 70 10             	push   0x10(%eax)
80105111:	68 0c 6f 10 80       	push   $0x80106f0c
80105116:	e8 ec b4 ff ff       	call   80100607 <cprintf>
    myproc()->killed = 1;
8010511b:	83 c4 20             	add    $0x20,%esp
8010511e:	e8 9f e0 ff ff       	call   801031c2 <myproc>
80105123:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010512a:	e9 a4 fe ff ff       	jmp    80104fd3 <trap+0x66>
8010512f:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105132:	8b 73 38             	mov    0x38(%ebx),%esi
80105135:	e8 6d e0 ff ff       	call   801031a7 <cpuid>
8010513a:	83 ec 0c             	sub    $0xc,%esp
8010513d:	57                   	push   %edi
8010513e:	56                   	push   %esi
8010513f:	50                   	push   %eax
80105140:	ff 73 30             	push   0x30(%ebx)
80105143:	68 d8 6e 10 80       	push   $0x80106ed8
80105148:	e8 ba b4 ff ff       	call   80100607 <cprintf>
      panic("trap");
8010514d:	83 c4 14             	add    $0x14,%esp
80105150:	68 ae 6e 10 80       	push   $0x80106eae
80105155:	e8 ee b1 ff ff       	call   80100348 <panic>
    exit();
8010515a:	e8 b4 e4 ff ff       	call   80103613 <exit>
8010515f:	e9 94 fe ff ff       	jmp    80104ff8 <trap+0x8b>
  if(myproc() && myproc()->state == RUNNING &&
80105164:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105168:	0f 85 a2 fe ff ff    	jne    80105010 <trap+0xa3>
    yield();
8010516e:	e8 69 e5 ff ff       	call   801036dc <yield>
80105173:	e9 98 fe ff ff       	jmp    80105010 <trap+0xa3>
    exit();
80105178:	e8 96 e4 ff ff       	call   80103613 <exit>
8010517d:	e9 b3 fe ff ff       	jmp    80105035 <trap+0xc8>

80105182 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105182:	83 3d c0 46 11 80 00 	cmpl   $0x0,0x801146c0
80105189:	74 14                	je     8010519f <uartgetc+0x1d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010518b:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105190:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105191:	a8 01                	test   $0x1,%al
80105193:	74 10                	je     801051a5 <uartgetc+0x23>
80105195:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010519a:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010519b:	0f b6 c0             	movzbl %al,%eax
8010519e:	c3                   	ret    
    return -1;
8010519f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051a4:	c3                   	ret    
    return -1;
801051a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051aa:	c3                   	ret    

801051ab <uartputc>:
  if(!uart)
801051ab:	83 3d c0 46 11 80 00 	cmpl   $0x0,0x801146c0
801051b2:	74 3b                	je     801051ef <uartputc+0x44>
{
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	53                   	push   %ebx
801051b8:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801051bb:	bb 00 00 00 00       	mov    $0x0,%ebx
801051c0:	eb 10                	jmp    801051d2 <uartputc+0x27>
    microdelay(10);
801051c2:	83 ec 0c             	sub    $0xc,%esp
801051c5:	6a 0a                	push   $0xa
801051c7:	e8 cb d1 ff ff       	call   80102397 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801051cc:	83 c3 01             	add    $0x1,%ebx
801051cf:	83 c4 10             	add    $0x10,%esp
801051d2:	83 fb 7f             	cmp    $0x7f,%ebx
801051d5:	7f 0a                	jg     801051e1 <uartputc+0x36>
801051d7:	ba fd 03 00 00       	mov    $0x3fd,%edx
801051dc:	ec                   	in     (%dx),%al
801051dd:	a8 20                	test   $0x20,%al
801051df:	74 e1                	je     801051c2 <uartputc+0x17>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801051e1:	8b 45 08             	mov    0x8(%ebp),%eax
801051e4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801051e9:	ee                   	out    %al,(%dx)
}
801051ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051ed:	c9                   	leave  
801051ee:	c3                   	ret    
801051ef:	c3                   	ret    

801051f0 <uartinit>:
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	56                   	push   %esi
801051f4:	53                   	push   %ebx
801051f5:	b9 00 00 00 00       	mov    $0x0,%ecx
801051fa:	ba fa 03 00 00       	mov    $0x3fa,%edx
801051ff:	89 c8                	mov    %ecx,%eax
80105201:	ee                   	out    %al,(%dx)
80105202:	be fb 03 00 00       	mov    $0x3fb,%esi
80105207:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010520c:	89 f2                	mov    %esi,%edx
8010520e:	ee                   	out    %al,(%dx)
8010520f:	b8 0c 00 00 00       	mov    $0xc,%eax
80105214:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105219:	ee                   	out    %al,(%dx)
8010521a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010521f:	89 c8                	mov    %ecx,%eax
80105221:	89 da                	mov    %ebx,%edx
80105223:	ee                   	out    %al,(%dx)
80105224:	b8 03 00 00 00       	mov    $0x3,%eax
80105229:	89 f2                	mov    %esi,%edx
8010522b:	ee                   	out    %al,(%dx)
8010522c:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105231:	89 c8                	mov    %ecx,%eax
80105233:	ee                   	out    %al,(%dx)
80105234:	b8 01 00 00 00       	mov    $0x1,%eax
80105239:	89 da                	mov    %ebx,%edx
8010523b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010523c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105241:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105242:	3c ff                	cmp    $0xff,%al
80105244:	74 45                	je     8010528b <uartinit+0x9b>
  uart = 1;
80105246:	c7 05 c0 46 11 80 01 	movl   $0x1,0x801146c0
8010524d:	00 00 00 
80105250:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105255:	ec                   	in     (%dx),%al
80105256:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010525b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010525c:	83 ec 08             	sub    $0x8,%esp
8010525f:	6a 00                	push   $0x0
80105261:	6a 04                	push   $0x4
80105263:	e8 f9 cc ff ff       	call   80101f61 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105268:	83 c4 10             	add    $0x10,%esp
8010526b:	bb d0 6f 10 80       	mov    $0x80106fd0,%ebx
80105270:	eb 12                	jmp    80105284 <uartinit+0x94>
    uartputc(*p);
80105272:	83 ec 0c             	sub    $0xc,%esp
80105275:	0f be c0             	movsbl %al,%eax
80105278:	50                   	push   %eax
80105279:	e8 2d ff ff ff       	call   801051ab <uartputc>
  for(p="xv6...\n"; *p; p++)
8010527e:	83 c3 01             	add    $0x1,%ebx
80105281:	83 c4 10             	add    $0x10,%esp
80105284:	0f b6 03             	movzbl (%ebx),%eax
80105287:	84 c0                	test   %al,%al
80105289:	75 e7                	jne    80105272 <uartinit+0x82>
}
8010528b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010528e:	5b                   	pop    %ebx
8010528f:	5e                   	pop    %esi
80105290:	5d                   	pop    %ebp
80105291:	c3                   	ret    

80105292 <uartintr>:

void
uartintr(void)
{
80105292:	55                   	push   %ebp
80105293:	89 e5                	mov    %esp,%ebp
80105295:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105298:	68 82 51 10 80       	push   $0x80105182
8010529d:	e8 91 b4 ff ff       	call   80100733 <consoleintr>
}
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	c9                   	leave  
801052a6:	c3                   	ret    

801052a7 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801052a7:	6a 00                	push   $0x0
  pushl $0
801052a9:	6a 00                	push   $0x0
  jmp alltraps
801052ab:	e9 71 fb ff ff       	jmp    80104e21 <alltraps>

801052b0 <vector1>:
.globl vector1
vector1:
  pushl $0
801052b0:	6a 00                	push   $0x0
  pushl $1
801052b2:	6a 01                	push   $0x1
  jmp alltraps
801052b4:	e9 68 fb ff ff       	jmp    80104e21 <alltraps>

801052b9 <vector2>:
.globl vector2
vector2:
  pushl $0
801052b9:	6a 00                	push   $0x0
  pushl $2
801052bb:	6a 02                	push   $0x2
  jmp alltraps
801052bd:	e9 5f fb ff ff       	jmp    80104e21 <alltraps>

801052c2 <vector3>:
.globl vector3
vector3:
  pushl $0
801052c2:	6a 00                	push   $0x0
  pushl $3
801052c4:	6a 03                	push   $0x3
  jmp alltraps
801052c6:	e9 56 fb ff ff       	jmp    80104e21 <alltraps>

801052cb <vector4>:
.globl vector4
vector4:
  pushl $0
801052cb:	6a 00                	push   $0x0
  pushl $4
801052cd:	6a 04                	push   $0x4
  jmp alltraps
801052cf:	e9 4d fb ff ff       	jmp    80104e21 <alltraps>

801052d4 <vector5>:
.globl vector5
vector5:
  pushl $0
801052d4:	6a 00                	push   $0x0
  pushl $5
801052d6:	6a 05                	push   $0x5
  jmp alltraps
801052d8:	e9 44 fb ff ff       	jmp    80104e21 <alltraps>

801052dd <vector6>:
.globl vector6
vector6:
  pushl $0
801052dd:	6a 00                	push   $0x0
  pushl $6
801052df:	6a 06                	push   $0x6
  jmp alltraps
801052e1:	e9 3b fb ff ff       	jmp    80104e21 <alltraps>

801052e6 <vector7>:
.globl vector7
vector7:
  pushl $0
801052e6:	6a 00                	push   $0x0
  pushl $7
801052e8:	6a 07                	push   $0x7
  jmp alltraps
801052ea:	e9 32 fb ff ff       	jmp    80104e21 <alltraps>

801052ef <vector8>:
.globl vector8
vector8:
  pushl $8
801052ef:	6a 08                	push   $0x8
  jmp alltraps
801052f1:	e9 2b fb ff ff       	jmp    80104e21 <alltraps>

801052f6 <vector9>:
.globl vector9
vector9:
  pushl $0
801052f6:	6a 00                	push   $0x0
  pushl $9
801052f8:	6a 09                	push   $0x9
  jmp alltraps
801052fa:	e9 22 fb ff ff       	jmp    80104e21 <alltraps>

801052ff <vector10>:
.globl vector10
vector10:
  pushl $10
801052ff:	6a 0a                	push   $0xa
  jmp alltraps
80105301:	e9 1b fb ff ff       	jmp    80104e21 <alltraps>

80105306 <vector11>:
.globl vector11
vector11:
  pushl $11
80105306:	6a 0b                	push   $0xb
  jmp alltraps
80105308:	e9 14 fb ff ff       	jmp    80104e21 <alltraps>

8010530d <vector12>:
.globl vector12
vector12:
  pushl $12
8010530d:	6a 0c                	push   $0xc
  jmp alltraps
8010530f:	e9 0d fb ff ff       	jmp    80104e21 <alltraps>

80105314 <vector13>:
.globl vector13
vector13:
  pushl $13
80105314:	6a 0d                	push   $0xd
  jmp alltraps
80105316:	e9 06 fb ff ff       	jmp    80104e21 <alltraps>

8010531b <vector14>:
.globl vector14
vector14:
  pushl $14
8010531b:	6a 0e                	push   $0xe
  jmp alltraps
8010531d:	e9 ff fa ff ff       	jmp    80104e21 <alltraps>

80105322 <vector15>:
.globl vector15
vector15:
  pushl $0
80105322:	6a 00                	push   $0x0
  pushl $15
80105324:	6a 0f                	push   $0xf
  jmp alltraps
80105326:	e9 f6 fa ff ff       	jmp    80104e21 <alltraps>

8010532b <vector16>:
.globl vector16
vector16:
  pushl $0
8010532b:	6a 00                	push   $0x0
  pushl $16
8010532d:	6a 10                	push   $0x10
  jmp alltraps
8010532f:	e9 ed fa ff ff       	jmp    80104e21 <alltraps>

80105334 <vector17>:
.globl vector17
vector17:
  pushl $17
80105334:	6a 11                	push   $0x11
  jmp alltraps
80105336:	e9 e6 fa ff ff       	jmp    80104e21 <alltraps>

8010533b <vector18>:
.globl vector18
vector18:
  pushl $0
8010533b:	6a 00                	push   $0x0
  pushl $18
8010533d:	6a 12                	push   $0x12
  jmp alltraps
8010533f:	e9 dd fa ff ff       	jmp    80104e21 <alltraps>

80105344 <vector19>:
.globl vector19
vector19:
  pushl $0
80105344:	6a 00                	push   $0x0
  pushl $19
80105346:	6a 13                	push   $0x13
  jmp alltraps
80105348:	e9 d4 fa ff ff       	jmp    80104e21 <alltraps>

8010534d <vector20>:
.globl vector20
vector20:
  pushl $0
8010534d:	6a 00                	push   $0x0
  pushl $20
8010534f:	6a 14                	push   $0x14
  jmp alltraps
80105351:	e9 cb fa ff ff       	jmp    80104e21 <alltraps>

80105356 <vector21>:
.globl vector21
vector21:
  pushl $0
80105356:	6a 00                	push   $0x0
  pushl $21
80105358:	6a 15                	push   $0x15
  jmp alltraps
8010535a:	e9 c2 fa ff ff       	jmp    80104e21 <alltraps>

8010535f <vector22>:
.globl vector22
vector22:
  pushl $0
8010535f:	6a 00                	push   $0x0
  pushl $22
80105361:	6a 16                	push   $0x16
  jmp alltraps
80105363:	e9 b9 fa ff ff       	jmp    80104e21 <alltraps>

80105368 <vector23>:
.globl vector23
vector23:
  pushl $0
80105368:	6a 00                	push   $0x0
  pushl $23
8010536a:	6a 17                	push   $0x17
  jmp alltraps
8010536c:	e9 b0 fa ff ff       	jmp    80104e21 <alltraps>

80105371 <vector24>:
.globl vector24
vector24:
  pushl $0
80105371:	6a 00                	push   $0x0
  pushl $24
80105373:	6a 18                	push   $0x18
  jmp alltraps
80105375:	e9 a7 fa ff ff       	jmp    80104e21 <alltraps>

8010537a <vector25>:
.globl vector25
vector25:
  pushl $0
8010537a:	6a 00                	push   $0x0
  pushl $25
8010537c:	6a 19                	push   $0x19
  jmp alltraps
8010537e:	e9 9e fa ff ff       	jmp    80104e21 <alltraps>

80105383 <vector26>:
.globl vector26
vector26:
  pushl $0
80105383:	6a 00                	push   $0x0
  pushl $26
80105385:	6a 1a                	push   $0x1a
  jmp alltraps
80105387:	e9 95 fa ff ff       	jmp    80104e21 <alltraps>

8010538c <vector27>:
.globl vector27
vector27:
  pushl $0
8010538c:	6a 00                	push   $0x0
  pushl $27
8010538e:	6a 1b                	push   $0x1b
  jmp alltraps
80105390:	e9 8c fa ff ff       	jmp    80104e21 <alltraps>

80105395 <vector28>:
.globl vector28
vector28:
  pushl $0
80105395:	6a 00                	push   $0x0
  pushl $28
80105397:	6a 1c                	push   $0x1c
  jmp alltraps
80105399:	e9 83 fa ff ff       	jmp    80104e21 <alltraps>

8010539e <vector29>:
.globl vector29
vector29:
  pushl $0
8010539e:	6a 00                	push   $0x0
  pushl $29
801053a0:	6a 1d                	push   $0x1d
  jmp alltraps
801053a2:	e9 7a fa ff ff       	jmp    80104e21 <alltraps>

801053a7 <vector30>:
.globl vector30
vector30:
  pushl $0
801053a7:	6a 00                	push   $0x0
  pushl $30
801053a9:	6a 1e                	push   $0x1e
  jmp alltraps
801053ab:	e9 71 fa ff ff       	jmp    80104e21 <alltraps>

801053b0 <vector31>:
.globl vector31
vector31:
  pushl $0
801053b0:	6a 00                	push   $0x0
  pushl $31
801053b2:	6a 1f                	push   $0x1f
  jmp alltraps
801053b4:	e9 68 fa ff ff       	jmp    80104e21 <alltraps>

801053b9 <vector32>:
.globl vector32
vector32:
  pushl $0
801053b9:	6a 00                	push   $0x0
  pushl $32
801053bb:	6a 20                	push   $0x20
  jmp alltraps
801053bd:	e9 5f fa ff ff       	jmp    80104e21 <alltraps>

801053c2 <vector33>:
.globl vector33
vector33:
  pushl $0
801053c2:	6a 00                	push   $0x0
  pushl $33
801053c4:	6a 21                	push   $0x21
  jmp alltraps
801053c6:	e9 56 fa ff ff       	jmp    80104e21 <alltraps>

801053cb <vector34>:
.globl vector34
vector34:
  pushl $0
801053cb:	6a 00                	push   $0x0
  pushl $34
801053cd:	6a 22                	push   $0x22
  jmp alltraps
801053cf:	e9 4d fa ff ff       	jmp    80104e21 <alltraps>

801053d4 <vector35>:
.globl vector35
vector35:
  pushl $0
801053d4:	6a 00                	push   $0x0
  pushl $35
801053d6:	6a 23                	push   $0x23
  jmp alltraps
801053d8:	e9 44 fa ff ff       	jmp    80104e21 <alltraps>

801053dd <vector36>:
.globl vector36
vector36:
  pushl $0
801053dd:	6a 00                	push   $0x0
  pushl $36
801053df:	6a 24                	push   $0x24
  jmp alltraps
801053e1:	e9 3b fa ff ff       	jmp    80104e21 <alltraps>

801053e6 <vector37>:
.globl vector37
vector37:
  pushl $0
801053e6:	6a 00                	push   $0x0
  pushl $37
801053e8:	6a 25                	push   $0x25
  jmp alltraps
801053ea:	e9 32 fa ff ff       	jmp    80104e21 <alltraps>

801053ef <vector38>:
.globl vector38
vector38:
  pushl $0
801053ef:	6a 00                	push   $0x0
  pushl $38
801053f1:	6a 26                	push   $0x26
  jmp alltraps
801053f3:	e9 29 fa ff ff       	jmp    80104e21 <alltraps>

801053f8 <vector39>:
.globl vector39
vector39:
  pushl $0
801053f8:	6a 00                	push   $0x0
  pushl $39
801053fa:	6a 27                	push   $0x27
  jmp alltraps
801053fc:	e9 20 fa ff ff       	jmp    80104e21 <alltraps>

80105401 <vector40>:
.globl vector40
vector40:
  pushl $0
80105401:	6a 00                	push   $0x0
  pushl $40
80105403:	6a 28                	push   $0x28
  jmp alltraps
80105405:	e9 17 fa ff ff       	jmp    80104e21 <alltraps>

8010540a <vector41>:
.globl vector41
vector41:
  pushl $0
8010540a:	6a 00                	push   $0x0
  pushl $41
8010540c:	6a 29                	push   $0x29
  jmp alltraps
8010540e:	e9 0e fa ff ff       	jmp    80104e21 <alltraps>

80105413 <vector42>:
.globl vector42
vector42:
  pushl $0
80105413:	6a 00                	push   $0x0
  pushl $42
80105415:	6a 2a                	push   $0x2a
  jmp alltraps
80105417:	e9 05 fa ff ff       	jmp    80104e21 <alltraps>

8010541c <vector43>:
.globl vector43
vector43:
  pushl $0
8010541c:	6a 00                	push   $0x0
  pushl $43
8010541e:	6a 2b                	push   $0x2b
  jmp alltraps
80105420:	e9 fc f9 ff ff       	jmp    80104e21 <alltraps>

80105425 <vector44>:
.globl vector44
vector44:
  pushl $0
80105425:	6a 00                	push   $0x0
  pushl $44
80105427:	6a 2c                	push   $0x2c
  jmp alltraps
80105429:	e9 f3 f9 ff ff       	jmp    80104e21 <alltraps>

8010542e <vector45>:
.globl vector45
vector45:
  pushl $0
8010542e:	6a 00                	push   $0x0
  pushl $45
80105430:	6a 2d                	push   $0x2d
  jmp alltraps
80105432:	e9 ea f9 ff ff       	jmp    80104e21 <alltraps>

80105437 <vector46>:
.globl vector46
vector46:
  pushl $0
80105437:	6a 00                	push   $0x0
  pushl $46
80105439:	6a 2e                	push   $0x2e
  jmp alltraps
8010543b:	e9 e1 f9 ff ff       	jmp    80104e21 <alltraps>

80105440 <vector47>:
.globl vector47
vector47:
  pushl $0
80105440:	6a 00                	push   $0x0
  pushl $47
80105442:	6a 2f                	push   $0x2f
  jmp alltraps
80105444:	e9 d8 f9 ff ff       	jmp    80104e21 <alltraps>

80105449 <vector48>:
.globl vector48
vector48:
  pushl $0
80105449:	6a 00                	push   $0x0
  pushl $48
8010544b:	6a 30                	push   $0x30
  jmp alltraps
8010544d:	e9 cf f9 ff ff       	jmp    80104e21 <alltraps>

80105452 <vector49>:
.globl vector49
vector49:
  pushl $0
80105452:	6a 00                	push   $0x0
  pushl $49
80105454:	6a 31                	push   $0x31
  jmp alltraps
80105456:	e9 c6 f9 ff ff       	jmp    80104e21 <alltraps>

8010545b <vector50>:
.globl vector50
vector50:
  pushl $0
8010545b:	6a 00                	push   $0x0
  pushl $50
8010545d:	6a 32                	push   $0x32
  jmp alltraps
8010545f:	e9 bd f9 ff ff       	jmp    80104e21 <alltraps>

80105464 <vector51>:
.globl vector51
vector51:
  pushl $0
80105464:	6a 00                	push   $0x0
  pushl $51
80105466:	6a 33                	push   $0x33
  jmp alltraps
80105468:	e9 b4 f9 ff ff       	jmp    80104e21 <alltraps>

8010546d <vector52>:
.globl vector52
vector52:
  pushl $0
8010546d:	6a 00                	push   $0x0
  pushl $52
8010546f:	6a 34                	push   $0x34
  jmp alltraps
80105471:	e9 ab f9 ff ff       	jmp    80104e21 <alltraps>

80105476 <vector53>:
.globl vector53
vector53:
  pushl $0
80105476:	6a 00                	push   $0x0
  pushl $53
80105478:	6a 35                	push   $0x35
  jmp alltraps
8010547a:	e9 a2 f9 ff ff       	jmp    80104e21 <alltraps>

8010547f <vector54>:
.globl vector54
vector54:
  pushl $0
8010547f:	6a 00                	push   $0x0
  pushl $54
80105481:	6a 36                	push   $0x36
  jmp alltraps
80105483:	e9 99 f9 ff ff       	jmp    80104e21 <alltraps>

80105488 <vector55>:
.globl vector55
vector55:
  pushl $0
80105488:	6a 00                	push   $0x0
  pushl $55
8010548a:	6a 37                	push   $0x37
  jmp alltraps
8010548c:	e9 90 f9 ff ff       	jmp    80104e21 <alltraps>

80105491 <vector56>:
.globl vector56
vector56:
  pushl $0
80105491:	6a 00                	push   $0x0
  pushl $56
80105493:	6a 38                	push   $0x38
  jmp alltraps
80105495:	e9 87 f9 ff ff       	jmp    80104e21 <alltraps>

8010549a <vector57>:
.globl vector57
vector57:
  pushl $0
8010549a:	6a 00                	push   $0x0
  pushl $57
8010549c:	6a 39                	push   $0x39
  jmp alltraps
8010549e:	e9 7e f9 ff ff       	jmp    80104e21 <alltraps>

801054a3 <vector58>:
.globl vector58
vector58:
  pushl $0
801054a3:	6a 00                	push   $0x0
  pushl $58
801054a5:	6a 3a                	push   $0x3a
  jmp alltraps
801054a7:	e9 75 f9 ff ff       	jmp    80104e21 <alltraps>

801054ac <vector59>:
.globl vector59
vector59:
  pushl $0
801054ac:	6a 00                	push   $0x0
  pushl $59
801054ae:	6a 3b                	push   $0x3b
  jmp alltraps
801054b0:	e9 6c f9 ff ff       	jmp    80104e21 <alltraps>

801054b5 <vector60>:
.globl vector60
vector60:
  pushl $0
801054b5:	6a 00                	push   $0x0
  pushl $60
801054b7:	6a 3c                	push   $0x3c
  jmp alltraps
801054b9:	e9 63 f9 ff ff       	jmp    80104e21 <alltraps>

801054be <vector61>:
.globl vector61
vector61:
  pushl $0
801054be:	6a 00                	push   $0x0
  pushl $61
801054c0:	6a 3d                	push   $0x3d
  jmp alltraps
801054c2:	e9 5a f9 ff ff       	jmp    80104e21 <alltraps>

801054c7 <vector62>:
.globl vector62
vector62:
  pushl $0
801054c7:	6a 00                	push   $0x0
  pushl $62
801054c9:	6a 3e                	push   $0x3e
  jmp alltraps
801054cb:	e9 51 f9 ff ff       	jmp    80104e21 <alltraps>

801054d0 <vector63>:
.globl vector63
vector63:
  pushl $0
801054d0:	6a 00                	push   $0x0
  pushl $63
801054d2:	6a 3f                	push   $0x3f
  jmp alltraps
801054d4:	e9 48 f9 ff ff       	jmp    80104e21 <alltraps>

801054d9 <vector64>:
.globl vector64
vector64:
  pushl $0
801054d9:	6a 00                	push   $0x0
  pushl $64
801054db:	6a 40                	push   $0x40
  jmp alltraps
801054dd:	e9 3f f9 ff ff       	jmp    80104e21 <alltraps>

801054e2 <vector65>:
.globl vector65
vector65:
  pushl $0
801054e2:	6a 00                	push   $0x0
  pushl $65
801054e4:	6a 41                	push   $0x41
  jmp alltraps
801054e6:	e9 36 f9 ff ff       	jmp    80104e21 <alltraps>

801054eb <vector66>:
.globl vector66
vector66:
  pushl $0
801054eb:	6a 00                	push   $0x0
  pushl $66
801054ed:	6a 42                	push   $0x42
  jmp alltraps
801054ef:	e9 2d f9 ff ff       	jmp    80104e21 <alltraps>

801054f4 <vector67>:
.globl vector67
vector67:
  pushl $0
801054f4:	6a 00                	push   $0x0
  pushl $67
801054f6:	6a 43                	push   $0x43
  jmp alltraps
801054f8:	e9 24 f9 ff ff       	jmp    80104e21 <alltraps>

801054fd <vector68>:
.globl vector68
vector68:
  pushl $0
801054fd:	6a 00                	push   $0x0
  pushl $68
801054ff:	6a 44                	push   $0x44
  jmp alltraps
80105501:	e9 1b f9 ff ff       	jmp    80104e21 <alltraps>

80105506 <vector69>:
.globl vector69
vector69:
  pushl $0
80105506:	6a 00                	push   $0x0
  pushl $69
80105508:	6a 45                	push   $0x45
  jmp alltraps
8010550a:	e9 12 f9 ff ff       	jmp    80104e21 <alltraps>

8010550f <vector70>:
.globl vector70
vector70:
  pushl $0
8010550f:	6a 00                	push   $0x0
  pushl $70
80105511:	6a 46                	push   $0x46
  jmp alltraps
80105513:	e9 09 f9 ff ff       	jmp    80104e21 <alltraps>

80105518 <vector71>:
.globl vector71
vector71:
  pushl $0
80105518:	6a 00                	push   $0x0
  pushl $71
8010551a:	6a 47                	push   $0x47
  jmp alltraps
8010551c:	e9 00 f9 ff ff       	jmp    80104e21 <alltraps>

80105521 <vector72>:
.globl vector72
vector72:
  pushl $0
80105521:	6a 00                	push   $0x0
  pushl $72
80105523:	6a 48                	push   $0x48
  jmp alltraps
80105525:	e9 f7 f8 ff ff       	jmp    80104e21 <alltraps>

8010552a <vector73>:
.globl vector73
vector73:
  pushl $0
8010552a:	6a 00                	push   $0x0
  pushl $73
8010552c:	6a 49                	push   $0x49
  jmp alltraps
8010552e:	e9 ee f8 ff ff       	jmp    80104e21 <alltraps>

80105533 <vector74>:
.globl vector74
vector74:
  pushl $0
80105533:	6a 00                	push   $0x0
  pushl $74
80105535:	6a 4a                	push   $0x4a
  jmp alltraps
80105537:	e9 e5 f8 ff ff       	jmp    80104e21 <alltraps>

8010553c <vector75>:
.globl vector75
vector75:
  pushl $0
8010553c:	6a 00                	push   $0x0
  pushl $75
8010553e:	6a 4b                	push   $0x4b
  jmp alltraps
80105540:	e9 dc f8 ff ff       	jmp    80104e21 <alltraps>

80105545 <vector76>:
.globl vector76
vector76:
  pushl $0
80105545:	6a 00                	push   $0x0
  pushl $76
80105547:	6a 4c                	push   $0x4c
  jmp alltraps
80105549:	e9 d3 f8 ff ff       	jmp    80104e21 <alltraps>

8010554e <vector77>:
.globl vector77
vector77:
  pushl $0
8010554e:	6a 00                	push   $0x0
  pushl $77
80105550:	6a 4d                	push   $0x4d
  jmp alltraps
80105552:	e9 ca f8 ff ff       	jmp    80104e21 <alltraps>

80105557 <vector78>:
.globl vector78
vector78:
  pushl $0
80105557:	6a 00                	push   $0x0
  pushl $78
80105559:	6a 4e                	push   $0x4e
  jmp alltraps
8010555b:	e9 c1 f8 ff ff       	jmp    80104e21 <alltraps>

80105560 <vector79>:
.globl vector79
vector79:
  pushl $0
80105560:	6a 00                	push   $0x0
  pushl $79
80105562:	6a 4f                	push   $0x4f
  jmp alltraps
80105564:	e9 b8 f8 ff ff       	jmp    80104e21 <alltraps>

80105569 <vector80>:
.globl vector80
vector80:
  pushl $0
80105569:	6a 00                	push   $0x0
  pushl $80
8010556b:	6a 50                	push   $0x50
  jmp alltraps
8010556d:	e9 af f8 ff ff       	jmp    80104e21 <alltraps>

80105572 <vector81>:
.globl vector81
vector81:
  pushl $0
80105572:	6a 00                	push   $0x0
  pushl $81
80105574:	6a 51                	push   $0x51
  jmp alltraps
80105576:	e9 a6 f8 ff ff       	jmp    80104e21 <alltraps>

8010557b <vector82>:
.globl vector82
vector82:
  pushl $0
8010557b:	6a 00                	push   $0x0
  pushl $82
8010557d:	6a 52                	push   $0x52
  jmp alltraps
8010557f:	e9 9d f8 ff ff       	jmp    80104e21 <alltraps>

80105584 <vector83>:
.globl vector83
vector83:
  pushl $0
80105584:	6a 00                	push   $0x0
  pushl $83
80105586:	6a 53                	push   $0x53
  jmp alltraps
80105588:	e9 94 f8 ff ff       	jmp    80104e21 <alltraps>

8010558d <vector84>:
.globl vector84
vector84:
  pushl $0
8010558d:	6a 00                	push   $0x0
  pushl $84
8010558f:	6a 54                	push   $0x54
  jmp alltraps
80105591:	e9 8b f8 ff ff       	jmp    80104e21 <alltraps>

80105596 <vector85>:
.globl vector85
vector85:
  pushl $0
80105596:	6a 00                	push   $0x0
  pushl $85
80105598:	6a 55                	push   $0x55
  jmp alltraps
8010559a:	e9 82 f8 ff ff       	jmp    80104e21 <alltraps>

8010559f <vector86>:
.globl vector86
vector86:
  pushl $0
8010559f:	6a 00                	push   $0x0
  pushl $86
801055a1:	6a 56                	push   $0x56
  jmp alltraps
801055a3:	e9 79 f8 ff ff       	jmp    80104e21 <alltraps>

801055a8 <vector87>:
.globl vector87
vector87:
  pushl $0
801055a8:	6a 00                	push   $0x0
  pushl $87
801055aa:	6a 57                	push   $0x57
  jmp alltraps
801055ac:	e9 70 f8 ff ff       	jmp    80104e21 <alltraps>

801055b1 <vector88>:
.globl vector88
vector88:
  pushl $0
801055b1:	6a 00                	push   $0x0
  pushl $88
801055b3:	6a 58                	push   $0x58
  jmp alltraps
801055b5:	e9 67 f8 ff ff       	jmp    80104e21 <alltraps>

801055ba <vector89>:
.globl vector89
vector89:
  pushl $0
801055ba:	6a 00                	push   $0x0
  pushl $89
801055bc:	6a 59                	push   $0x59
  jmp alltraps
801055be:	e9 5e f8 ff ff       	jmp    80104e21 <alltraps>

801055c3 <vector90>:
.globl vector90
vector90:
  pushl $0
801055c3:	6a 00                	push   $0x0
  pushl $90
801055c5:	6a 5a                	push   $0x5a
  jmp alltraps
801055c7:	e9 55 f8 ff ff       	jmp    80104e21 <alltraps>

801055cc <vector91>:
.globl vector91
vector91:
  pushl $0
801055cc:	6a 00                	push   $0x0
  pushl $91
801055ce:	6a 5b                	push   $0x5b
  jmp alltraps
801055d0:	e9 4c f8 ff ff       	jmp    80104e21 <alltraps>

801055d5 <vector92>:
.globl vector92
vector92:
  pushl $0
801055d5:	6a 00                	push   $0x0
  pushl $92
801055d7:	6a 5c                	push   $0x5c
  jmp alltraps
801055d9:	e9 43 f8 ff ff       	jmp    80104e21 <alltraps>

801055de <vector93>:
.globl vector93
vector93:
  pushl $0
801055de:	6a 00                	push   $0x0
  pushl $93
801055e0:	6a 5d                	push   $0x5d
  jmp alltraps
801055e2:	e9 3a f8 ff ff       	jmp    80104e21 <alltraps>

801055e7 <vector94>:
.globl vector94
vector94:
  pushl $0
801055e7:	6a 00                	push   $0x0
  pushl $94
801055e9:	6a 5e                	push   $0x5e
  jmp alltraps
801055eb:	e9 31 f8 ff ff       	jmp    80104e21 <alltraps>

801055f0 <vector95>:
.globl vector95
vector95:
  pushl $0
801055f0:	6a 00                	push   $0x0
  pushl $95
801055f2:	6a 5f                	push   $0x5f
  jmp alltraps
801055f4:	e9 28 f8 ff ff       	jmp    80104e21 <alltraps>

801055f9 <vector96>:
.globl vector96
vector96:
  pushl $0
801055f9:	6a 00                	push   $0x0
  pushl $96
801055fb:	6a 60                	push   $0x60
  jmp alltraps
801055fd:	e9 1f f8 ff ff       	jmp    80104e21 <alltraps>

80105602 <vector97>:
.globl vector97
vector97:
  pushl $0
80105602:	6a 00                	push   $0x0
  pushl $97
80105604:	6a 61                	push   $0x61
  jmp alltraps
80105606:	e9 16 f8 ff ff       	jmp    80104e21 <alltraps>

8010560b <vector98>:
.globl vector98
vector98:
  pushl $0
8010560b:	6a 00                	push   $0x0
  pushl $98
8010560d:	6a 62                	push   $0x62
  jmp alltraps
8010560f:	e9 0d f8 ff ff       	jmp    80104e21 <alltraps>

80105614 <vector99>:
.globl vector99
vector99:
  pushl $0
80105614:	6a 00                	push   $0x0
  pushl $99
80105616:	6a 63                	push   $0x63
  jmp alltraps
80105618:	e9 04 f8 ff ff       	jmp    80104e21 <alltraps>

8010561d <vector100>:
.globl vector100
vector100:
  pushl $0
8010561d:	6a 00                	push   $0x0
  pushl $100
8010561f:	6a 64                	push   $0x64
  jmp alltraps
80105621:	e9 fb f7 ff ff       	jmp    80104e21 <alltraps>

80105626 <vector101>:
.globl vector101
vector101:
  pushl $0
80105626:	6a 00                	push   $0x0
  pushl $101
80105628:	6a 65                	push   $0x65
  jmp alltraps
8010562a:	e9 f2 f7 ff ff       	jmp    80104e21 <alltraps>

8010562f <vector102>:
.globl vector102
vector102:
  pushl $0
8010562f:	6a 00                	push   $0x0
  pushl $102
80105631:	6a 66                	push   $0x66
  jmp alltraps
80105633:	e9 e9 f7 ff ff       	jmp    80104e21 <alltraps>

80105638 <vector103>:
.globl vector103
vector103:
  pushl $0
80105638:	6a 00                	push   $0x0
  pushl $103
8010563a:	6a 67                	push   $0x67
  jmp alltraps
8010563c:	e9 e0 f7 ff ff       	jmp    80104e21 <alltraps>

80105641 <vector104>:
.globl vector104
vector104:
  pushl $0
80105641:	6a 00                	push   $0x0
  pushl $104
80105643:	6a 68                	push   $0x68
  jmp alltraps
80105645:	e9 d7 f7 ff ff       	jmp    80104e21 <alltraps>

8010564a <vector105>:
.globl vector105
vector105:
  pushl $0
8010564a:	6a 00                	push   $0x0
  pushl $105
8010564c:	6a 69                	push   $0x69
  jmp alltraps
8010564e:	e9 ce f7 ff ff       	jmp    80104e21 <alltraps>

80105653 <vector106>:
.globl vector106
vector106:
  pushl $0
80105653:	6a 00                	push   $0x0
  pushl $106
80105655:	6a 6a                	push   $0x6a
  jmp alltraps
80105657:	e9 c5 f7 ff ff       	jmp    80104e21 <alltraps>

8010565c <vector107>:
.globl vector107
vector107:
  pushl $0
8010565c:	6a 00                	push   $0x0
  pushl $107
8010565e:	6a 6b                	push   $0x6b
  jmp alltraps
80105660:	e9 bc f7 ff ff       	jmp    80104e21 <alltraps>

80105665 <vector108>:
.globl vector108
vector108:
  pushl $0
80105665:	6a 00                	push   $0x0
  pushl $108
80105667:	6a 6c                	push   $0x6c
  jmp alltraps
80105669:	e9 b3 f7 ff ff       	jmp    80104e21 <alltraps>

8010566e <vector109>:
.globl vector109
vector109:
  pushl $0
8010566e:	6a 00                	push   $0x0
  pushl $109
80105670:	6a 6d                	push   $0x6d
  jmp alltraps
80105672:	e9 aa f7 ff ff       	jmp    80104e21 <alltraps>

80105677 <vector110>:
.globl vector110
vector110:
  pushl $0
80105677:	6a 00                	push   $0x0
  pushl $110
80105679:	6a 6e                	push   $0x6e
  jmp alltraps
8010567b:	e9 a1 f7 ff ff       	jmp    80104e21 <alltraps>

80105680 <vector111>:
.globl vector111
vector111:
  pushl $0
80105680:	6a 00                	push   $0x0
  pushl $111
80105682:	6a 6f                	push   $0x6f
  jmp alltraps
80105684:	e9 98 f7 ff ff       	jmp    80104e21 <alltraps>

80105689 <vector112>:
.globl vector112
vector112:
  pushl $0
80105689:	6a 00                	push   $0x0
  pushl $112
8010568b:	6a 70                	push   $0x70
  jmp alltraps
8010568d:	e9 8f f7 ff ff       	jmp    80104e21 <alltraps>

80105692 <vector113>:
.globl vector113
vector113:
  pushl $0
80105692:	6a 00                	push   $0x0
  pushl $113
80105694:	6a 71                	push   $0x71
  jmp alltraps
80105696:	e9 86 f7 ff ff       	jmp    80104e21 <alltraps>

8010569b <vector114>:
.globl vector114
vector114:
  pushl $0
8010569b:	6a 00                	push   $0x0
  pushl $114
8010569d:	6a 72                	push   $0x72
  jmp alltraps
8010569f:	e9 7d f7 ff ff       	jmp    80104e21 <alltraps>

801056a4 <vector115>:
.globl vector115
vector115:
  pushl $0
801056a4:	6a 00                	push   $0x0
  pushl $115
801056a6:	6a 73                	push   $0x73
  jmp alltraps
801056a8:	e9 74 f7 ff ff       	jmp    80104e21 <alltraps>

801056ad <vector116>:
.globl vector116
vector116:
  pushl $0
801056ad:	6a 00                	push   $0x0
  pushl $116
801056af:	6a 74                	push   $0x74
  jmp alltraps
801056b1:	e9 6b f7 ff ff       	jmp    80104e21 <alltraps>

801056b6 <vector117>:
.globl vector117
vector117:
  pushl $0
801056b6:	6a 00                	push   $0x0
  pushl $117
801056b8:	6a 75                	push   $0x75
  jmp alltraps
801056ba:	e9 62 f7 ff ff       	jmp    80104e21 <alltraps>

801056bf <vector118>:
.globl vector118
vector118:
  pushl $0
801056bf:	6a 00                	push   $0x0
  pushl $118
801056c1:	6a 76                	push   $0x76
  jmp alltraps
801056c3:	e9 59 f7 ff ff       	jmp    80104e21 <alltraps>

801056c8 <vector119>:
.globl vector119
vector119:
  pushl $0
801056c8:	6a 00                	push   $0x0
  pushl $119
801056ca:	6a 77                	push   $0x77
  jmp alltraps
801056cc:	e9 50 f7 ff ff       	jmp    80104e21 <alltraps>

801056d1 <vector120>:
.globl vector120
vector120:
  pushl $0
801056d1:	6a 00                	push   $0x0
  pushl $120
801056d3:	6a 78                	push   $0x78
  jmp alltraps
801056d5:	e9 47 f7 ff ff       	jmp    80104e21 <alltraps>

801056da <vector121>:
.globl vector121
vector121:
  pushl $0
801056da:	6a 00                	push   $0x0
  pushl $121
801056dc:	6a 79                	push   $0x79
  jmp alltraps
801056de:	e9 3e f7 ff ff       	jmp    80104e21 <alltraps>

801056e3 <vector122>:
.globl vector122
vector122:
  pushl $0
801056e3:	6a 00                	push   $0x0
  pushl $122
801056e5:	6a 7a                	push   $0x7a
  jmp alltraps
801056e7:	e9 35 f7 ff ff       	jmp    80104e21 <alltraps>

801056ec <vector123>:
.globl vector123
vector123:
  pushl $0
801056ec:	6a 00                	push   $0x0
  pushl $123
801056ee:	6a 7b                	push   $0x7b
  jmp alltraps
801056f0:	e9 2c f7 ff ff       	jmp    80104e21 <alltraps>

801056f5 <vector124>:
.globl vector124
vector124:
  pushl $0
801056f5:	6a 00                	push   $0x0
  pushl $124
801056f7:	6a 7c                	push   $0x7c
  jmp alltraps
801056f9:	e9 23 f7 ff ff       	jmp    80104e21 <alltraps>

801056fe <vector125>:
.globl vector125
vector125:
  pushl $0
801056fe:	6a 00                	push   $0x0
  pushl $125
80105700:	6a 7d                	push   $0x7d
  jmp alltraps
80105702:	e9 1a f7 ff ff       	jmp    80104e21 <alltraps>

80105707 <vector126>:
.globl vector126
vector126:
  pushl $0
80105707:	6a 00                	push   $0x0
  pushl $126
80105709:	6a 7e                	push   $0x7e
  jmp alltraps
8010570b:	e9 11 f7 ff ff       	jmp    80104e21 <alltraps>

80105710 <vector127>:
.globl vector127
vector127:
  pushl $0
80105710:	6a 00                	push   $0x0
  pushl $127
80105712:	6a 7f                	push   $0x7f
  jmp alltraps
80105714:	e9 08 f7 ff ff       	jmp    80104e21 <alltraps>

80105719 <vector128>:
.globl vector128
vector128:
  pushl $0
80105719:	6a 00                	push   $0x0
  pushl $128
8010571b:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105720:	e9 fc f6 ff ff       	jmp    80104e21 <alltraps>

80105725 <vector129>:
.globl vector129
vector129:
  pushl $0
80105725:	6a 00                	push   $0x0
  pushl $129
80105727:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010572c:	e9 f0 f6 ff ff       	jmp    80104e21 <alltraps>

80105731 <vector130>:
.globl vector130
vector130:
  pushl $0
80105731:	6a 00                	push   $0x0
  pushl $130
80105733:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105738:	e9 e4 f6 ff ff       	jmp    80104e21 <alltraps>

8010573d <vector131>:
.globl vector131
vector131:
  pushl $0
8010573d:	6a 00                	push   $0x0
  pushl $131
8010573f:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105744:	e9 d8 f6 ff ff       	jmp    80104e21 <alltraps>

80105749 <vector132>:
.globl vector132
vector132:
  pushl $0
80105749:	6a 00                	push   $0x0
  pushl $132
8010574b:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105750:	e9 cc f6 ff ff       	jmp    80104e21 <alltraps>

80105755 <vector133>:
.globl vector133
vector133:
  pushl $0
80105755:	6a 00                	push   $0x0
  pushl $133
80105757:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010575c:	e9 c0 f6 ff ff       	jmp    80104e21 <alltraps>

80105761 <vector134>:
.globl vector134
vector134:
  pushl $0
80105761:	6a 00                	push   $0x0
  pushl $134
80105763:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105768:	e9 b4 f6 ff ff       	jmp    80104e21 <alltraps>

8010576d <vector135>:
.globl vector135
vector135:
  pushl $0
8010576d:	6a 00                	push   $0x0
  pushl $135
8010576f:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105774:	e9 a8 f6 ff ff       	jmp    80104e21 <alltraps>

80105779 <vector136>:
.globl vector136
vector136:
  pushl $0
80105779:	6a 00                	push   $0x0
  pushl $136
8010577b:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105780:	e9 9c f6 ff ff       	jmp    80104e21 <alltraps>

80105785 <vector137>:
.globl vector137
vector137:
  pushl $0
80105785:	6a 00                	push   $0x0
  pushl $137
80105787:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010578c:	e9 90 f6 ff ff       	jmp    80104e21 <alltraps>

80105791 <vector138>:
.globl vector138
vector138:
  pushl $0
80105791:	6a 00                	push   $0x0
  pushl $138
80105793:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105798:	e9 84 f6 ff ff       	jmp    80104e21 <alltraps>

8010579d <vector139>:
.globl vector139
vector139:
  pushl $0
8010579d:	6a 00                	push   $0x0
  pushl $139
8010579f:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801057a4:	e9 78 f6 ff ff       	jmp    80104e21 <alltraps>

801057a9 <vector140>:
.globl vector140
vector140:
  pushl $0
801057a9:	6a 00                	push   $0x0
  pushl $140
801057ab:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801057b0:	e9 6c f6 ff ff       	jmp    80104e21 <alltraps>

801057b5 <vector141>:
.globl vector141
vector141:
  pushl $0
801057b5:	6a 00                	push   $0x0
  pushl $141
801057b7:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801057bc:	e9 60 f6 ff ff       	jmp    80104e21 <alltraps>

801057c1 <vector142>:
.globl vector142
vector142:
  pushl $0
801057c1:	6a 00                	push   $0x0
  pushl $142
801057c3:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801057c8:	e9 54 f6 ff ff       	jmp    80104e21 <alltraps>

801057cd <vector143>:
.globl vector143
vector143:
  pushl $0
801057cd:	6a 00                	push   $0x0
  pushl $143
801057cf:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801057d4:	e9 48 f6 ff ff       	jmp    80104e21 <alltraps>

801057d9 <vector144>:
.globl vector144
vector144:
  pushl $0
801057d9:	6a 00                	push   $0x0
  pushl $144
801057db:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801057e0:	e9 3c f6 ff ff       	jmp    80104e21 <alltraps>

801057e5 <vector145>:
.globl vector145
vector145:
  pushl $0
801057e5:	6a 00                	push   $0x0
  pushl $145
801057e7:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801057ec:	e9 30 f6 ff ff       	jmp    80104e21 <alltraps>

801057f1 <vector146>:
.globl vector146
vector146:
  pushl $0
801057f1:	6a 00                	push   $0x0
  pushl $146
801057f3:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801057f8:	e9 24 f6 ff ff       	jmp    80104e21 <alltraps>

801057fd <vector147>:
.globl vector147
vector147:
  pushl $0
801057fd:	6a 00                	push   $0x0
  pushl $147
801057ff:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105804:	e9 18 f6 ff ff       	jmp    80104e21 <alltraps>

80105809 <vector148>:
.globl vector148
vector148:
  pushl $0
80105809:	6a 00                	push   $0x0
  pushl $148
8010580b:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105810:	e9 0c f6 ff ff       	jmp    80104e21 <alltraps>

80105815 <vector149>:
.globl vector149
vector149:
  pushl $0
80105815:	6a 00                	push   $0x0
  pushl $149
80105817:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010581c:	e9 00 f6 ff ff       	jmp    80104e21 <alltraps>

80105821 <vector150>:
.globl vector150
vector150:
  pushl $0
80105821:	6a 00                	push   $0x0
  pushl $150
80105823:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105828:	e9 f4 f5 ff ff       	jmp    80104e21 <alltraps>

8010582d <vector151>:
.globl vector151
vector151:
  pushl $0
8010582d:	6a 00                	push   $0x0
  pushl $151
8010582f:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105834:	e9 e8 f5 ff ff       	jmp    80104e21 <alltraps>

80105839 <vector152>:
.globl vector152
vector152:
  pushl $0
80105839:	6a 00                	push   $0x0
  pushl $152
8010583b:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105840:	e9 dc f5 ff ff       	jmp    80104e21 <alltraps>

80105845 <vector153>:
.globl vector153
vector153:
  pushl $0
80105845:	6a 00                	push   $0x0
  pushl $153
80105847:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010584c:	e9 d0 f5 ff ff       	jmp    80104e21 <alltraps>

80105851 <vector154>:
.globl vector154
vector154:
  pushl $0
80105851:	6a 00                	push   $0x0
  pushl $154
80105853:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105858:	e9 c4 f5 ff ff       	jmp    80104e21 <alltraps>

8010585d <vector155>:
.globl vector155
vector155:
  pushl $0
8010585d:	6a 00                	push   $0x0
  pushl $155
8010585f:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105864:	e9 b8 f5 ff ff       	jmp    80104e21 <alltraps>

80105869 <vector156>:
.globl vector156
vector156:
  pushl $0
80105869:	6a 00                	push   $0x0
  pushl $156
8010586b:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105870:	e9 ac f5 ff ff       	jmp    80104e21 <alltraps>

80105875 <vector157>:
.globl vector157
vector157:
  pushl $0
80105875:	6a 00                	push   $0x0
  pushl $157
80105877:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010587c:	e9 a0 f5 ff ff       	jmp    80104e21 <alltraps>

80105881 <vector158>:
.globl vector158
vector158:
  pushl $0
80105881:	6a 00                	push   $0x0
  pushl $158
80105883:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105888:	e9 94 f5 ff ff       	jmp    80104e21 <alltraps>

8010588d <vector159>:
.globl vector159
vector159:
  pushl $0
8010588d:	6a 00                	push   $0x0
  pushl $159
8010588f:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105894:	e9 88 f5 ff ff       	jmp    80104e21 <alltraps>

80105899 <vector160>:
.globl vector160
vector160:
  pushl $0
80105899:	6a 00                	push   $0x0
  pushl $160
8010589b:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801058a0:	e9 7c f5 ff ff       	jmp    80104e21 <alltraps>

801058a5 <vector161>:
.globl vector161
vector161:
  pushl $0
801058a5:	6a 00                	push   $0x0
  pushl $161
801058a7:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801058ac:	e9 70 f5 ff ff       	jmp    80104e21 <alltraps>

801058b1 <vector162>:
.globl vector162
vector162:
  pushl $0
801058b1:	6a 00                	push   $0x0
  pushl $162
801058b3:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801058b8:	e9 64 f5 ff ff       	jmp    80104e21 <alltraps>

801058bd <vector163>:
.globl vector163
vector163:
  pushl $0
801058bd:	6a 00                	push   $0x0
  pushl $163
801058bf:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801058c4:	e9 58 f5 ff ff       	jmp    80104e21 <alltraps>

801058c9 <vector164>:
.globl vector164
vector164:
  pushl $0
801058c9:	6a 00                	push   $0x0
  pushl $164
801058cb:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801058d0:	e9 4c f5 ff ff       	jmp    80104e21 <alltraps>

801058d5 <vector165>:
.globl vector165
vector165:
  pushl $0
801058d5:	6a 00                	push   $0x0
  pushl $165
801058d7:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801058dc:	e9 40 f5 ff ff       	jmp    80104e21 <alltraps>

801058e1 <vector166>:
.globl vector166
vector166:
  pushl $0
801058e1:	6a 00                	push   $0x0
  pushl $166
801058e3:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801058e8:	e9 34 f5 ff ff       	jmp    80104e21 <alltraps>

801058ed <vector167>:
.globl vector167
vector167:
  pushl $0
801058ed:	6a 00                	push   $0x0
  pushl $167
801058ef:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801058f4:	e9 28 f5 ff ff       	jmp    80104e21 <alltraps>

801058f9 <vector168>:
.globl vector168
vector168:
  pushl $0
801058f9:	6a 00                	push   $0x0
  pushl $168
801058fb:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105900:	e9 1c f5 ff ff       	jmp    80104e21 <alltraps>

80105905 <vector169>:
.globl vector169
vector169:
  pushl $0
80105905:	6a 00                	push   $0x0
  pushl $169
80105907:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010590c:	e9 10 f5 ff ff       	jmp    80104e21 <alltraps>

80105911 <vector170>:
.globl vector170
vector170:
  pushl $0
80105911:	6a 00                	push   $0x0
  pushl $170
80105913:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105918:	e9 04 f5 ff ff       	jmp    80104e21 <alltraps>

8010591d <vector171>:
.globl vector171
vector171:
  pushl $0
8010591d:	6a 00                	push   $0x0
  pushl $171
8010591f:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105924:	e9 f8 f4 ff ff       	jmp    80104e21 <alltraps>

80105929 <vector172>:
.globl vector172
vector172:
  pushl $0
80105929:	6a 00                	push   $0x0
  pushl $172
8010592b:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105930:	e9 ec f4 ff ff       	jmp    80104e21 <alltraps>

80105935 <vector173>:
.globl vector173
vector173:
  pushl $0
80105935:	6a 00                	push   $0x0
  pushl $173
80105937:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010593c:	e9 e0 f4 ff ff       	jmp    80104e21 <alltraps>

80105941 <vector174>:
.globl vector174
vector174:
  pushl $0
80105941:	6a 00                	push   $0x0
  pushl $174
80105943:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105948:	e9 d4 f4 ff ff       	jmp    80104e21 <alltraps>

8010594d <vector175>:
.globl vector175
vector175:
  pushl $0
8010594d:	6a 00                	push   $0x0
  pushl $175
8010594f:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105954:	e9 c8 f4 ff ff       	jmp    80104e21 <alltraps>

80105959 <vector176>:
.globl vector176
vector176:
  pushl $0
80105959:	6a 00                	push   $0x0
  pushl $176
8010595b:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105960:	e9 bc f4 ff ff       	jmp    80104e21 <alltraps>

80105965 <vector177>:
.globl vector177
vector177:
  pushl $0
80105965:	6a 00                	push   $0x0
  pushl $177
80105967:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010596c:	e9 b0 f4 ff ff       	jmp    80104e21 <alltraps>

80105971 <vector178>:
.globl vector178
vector178:
  pushl $0
80105971:	6a 00                	push   $0x0
  pushl $178
80105973:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105978:	e9 a4 f4 ff ff       	jmp    80104e21 <alltraps>

8010597d <vector179>:
.globl vector179
vector179:
  pushl $0
8010597d:	6a 00                	push   $0x0
  pushl $179
8010597f:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105984:	e9 98 f4 ff ff       	jmp    80104e21 <alltraps>

80105989 <vector180>:
.globl vector180
vector180:
  pushl $0
80105989:	6a 00                	push   $0x0
  pushl $180
8010598b:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105990:	e9 8c f4 ff ff       	jmp    80104e21 <alltraps>

80105995 <vector181>:
.globl vector181
vector181:
  pushl $0
80105995:	6a 00                	push   $0x0
  pushl $181
80105997:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010599c:	e9 80 f4 ff ff       	jmp    80104e21 <alltraps>

801059a1 <vector182>:
.globl vector182
vector182:
  pushl $0
801059a1:	6a 00                	push   $0x0
  pushl $182
801059a3:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801059a8:	e9 74 f4 ff ff       	jmp    80104e21 <alltraps>

801059ad <vector183>:
.globl vector183
vector183:
  pushl $0
801059ad:	6a 00                	push   $0x0
  pushl $183
801059af:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801059b4:	e9 68 f4 ff ff       	jmp    80104e21 <alltraps>

801059b9 <vector184>:
.globl vector184
vector184:
  pushl $0
801059b9:	6a 00                	push   $0x0
  pushl $184
801059bb:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801059c0:	e9 5c f4 ff ff       	jmp    80104e21 <alltraps>

801059c5 <vector185>:
.globl vector185
vector185:
  pushl $0
801059c5:	6a 00                	push   $0x0
  pushl $185
801059c7:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801059cc:	e9 50 f4 ff ff       	jmp    80104e21 <alltraps>

801059d1 <vector186>:
.globl vector186
vector186:
  pushl $0
801059d1:	6a 00                	push   $0x0
  pushl $186
801059d3:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801059d8:	e9 44 f4 ff ff       	jmp    80104e21 <alltraps>

801059dd <vector187>:
.globl vector187
vector187:
  pushl $0
801059dd:	6a 00                	push   $0x0
  pushl $187
801059df:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801059e4:	e9 38 f4 ff ff       	jmp    80104e21 <alltraps>

801059e9 <vector188>:
.globl vector188
vector188:
  pushl $0
801059e9:	6a 00                	push   $0x0
  pushl $188
801059eb:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801059f0:	e9 2c f4 ff ff       	jmp    80104e21 <alltraps>

801059f5 <vector189>:
.globl vector189
vector189:
  pushl $0
801059f5:	6a 00                	push   $0x0
  pushl $189
801059f7:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801059fc:	e9 20 f4 ff ff       	jmp    80104e21 <alltraps>

80105a01 <vector190>:
.globl vector190
vector190:
  pushl $0
80105a01:	6a 00                	push   $0x0
  pushl $190
80105a03:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105a08:	e9 14 f4 ff ff       	jmp    80104e21 <alltraps>

80105a0d <vector191>:
.globl vector191
vector191:
  pushl $0
80105a0d:	6a 00                	push   $0x0
  pushl $191
80105a0f:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105a14:	e9 08 f4 ff ff       	jmp    80104e21 <alltraps>

80105a19 <vector192>:
.globl vector192
vector192:
  pushl $0
80105a19:	6a 00                	push   $0x0
  pushl $192
80105a1b:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105a20:	e9 fc f3 ff ff       	jmp    80104e21 <alltraps>

80105a25 <vector193>:
.globl vector193
vector193:
  pushl $0
80105a25:	6a 00                	push   $0x0
  pushl $193
80105a27:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105a2c:	e9 f0 f3 ff ff       	jmp    80104e21 <alltraps>

80105a31 <vector194>:
.globl vector194
vector194:
  pushl $0
80105a31:	6a 00                	push   $0x0
  pushl $194
80105a33:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105a38:	e9 e4 f3 ff ff       	jmp    80104e21 <alltraps>

80105a3d <vector195>:
.globl vector195
vector195:
  pushl $0
80105a3d:	6a 00                	push   $0x0
  pushl $195
80105a3f:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105a44:	e9 d8 f3 ff ff       	jmp    80104e21 <alltraps>

80105a49 <vector196>:
.globl vector196
vector196:
  pushl $0
80105a49:	6a 00                	push   $0x0
  pushl $196
80105a4b:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105a50:	e9 cc f3 ff ff       	jmp    80104e21 <alltraps>

80105a55 <vector197>:
.globl vector197
vector197:
  pushl $0
80105a55:	6a 00                	push   $0x0
  pushl $197
80105a57:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105a5c:	e9 c0 f3 ff ff       	jmp    80104e21 <alltraps>

80105a61 <vector198>:
.globl vector198
vector198:
  pushl $0
80105a61:	6a 00                	push   $0x0
  pushl $198
80105a63:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105a68:	e9 b4 f3 ff ff       	jmp    80104e21 <alltraps>

80105a6d <vector199>:
.globl vector199
vector199:
  pushl $0
80105a6d:	6a 00                	push   $0x0
  pushl $199
80105a6f:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105a74:	e9 a8 f3 ff ff       	jmp    80104e21 <alltraps>

80105a79 <vector200>:
.globl vector200
vector200:
  pushl $0
80105a79:	6a 00                	push   $0x0
  pushl $200
80105a7b:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105a80:	e9 9c f3 ff ff       	jmp    80104e21 <alltraps>

80105a85 <vector201>:
.globl vector201
vector201:
  pushl $0
80105a85:	6a 00                	push   $0x0
  pushl $201
80105a87:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105a8c:	e9 90 f3 ff ff       	jmp    80104e21 <alltraps>

80105a91 <vector202>:
.globl vector202
vector202:
  pushl $0
80105a91:	6a 00                	push   $0x0
  pushl $202
80105a93:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105a98:	e9 84 f3 ff ff       	jmp    80104e21 <alltraps>

80105a9d <vector203>:
.globl vector203
vector203:
  pushl $0
80105a9d:	6a 00                	push   $0x0
  pushl $203
80105a9f:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105aa4:	e9 78 f3 ff ff       	jmp    80104e21 <alltraps>

80105aa9 <vector204>:
.globl vector204
vector204:
  pushl $0
80105aa9:	6a 00                	push   $0x0
  pushl $204
80105aab:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105ab0:	e9 6c f3 ff ff       	jmp    80104e21 <alltraps>

80105ab5 <vector205>:
.globl vector205
vector205:
  pushl $0
80105ab5:	6a 00                	push   $0x0
  pushl $205
80105ab7:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105abc:	e9 60 f3 ff ff       	jmp    80104e21 <alltraps>

80105ac1 <vector206>:
.globl vector206
vector206:
  pushl $0
80105ac1:	6a 00                	push   $0x0
  pushl $206
80105ac3:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105ac8:	e9 54 f3 ff ff       	jmp    80104e21 <alltraps>

80105acd <vector207>:
.globl vector207
vector207:
  pushl $0
80105acd:	6a 00                	push   $0x0
  pushl $207
80105acf:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105ad4:	e9 48 f3 ff ff       	jmp    80104e21 <alltraps>

80105ad9 <vector208>:
.globl vector208
vector208:
  pushl $0
80105ad9:	6a 00                	push   $0x0
  pushl $208
80105adb:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105ae0:	e9 3c f3 ff ff       	jmp    80104e21 <alltraps>

80105ae5 <vector209>:
.globl vector209
vector209:
  pushl $0
80105ae5:	6a 00                	push   $0x0
  pushl $209
80105ae7:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105aec:	e9 30 f3 ff ff       	jmp    80104e21 <alltraps>

80105af1 <vector210>:
.globl vector210
vector210:
  pushl $0
80105af1:	6a 00                	push   $0x0
  pushl $210
80105af3:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105af8:	e9 24 f3 ff ff       	jmp    80104e21 <alltraps>

80105afd <vector211>:
.globl vector211
vector211:
  pushl $0
80105afd:	6a 00                	push   $0x0
  pushl $211
80105aff:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105b04:	e9 18 f3 ff ff       	jmp    80104e21 <alltraps>

80105b09 <vector212>:
.globl vector212
vector212:
  pushl $0
80105b09:	6a 00                	push   $0x0
  pushl $212
80105b0b:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105b10:	e9 0c f3 ff ff       	jmp    80104e21 <alltraps>

80105b15 <vector213>:
.globl vector213
vector213:
  pushl $0
80105b15:	6a 00                	push   $0x0
  pushl $213
80105b17:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105b1c:	e9 00 f3 ff ff       	jmp    80104e21 <alltraps>

80105b21 <vector214>:
.globl vector214
vector214:
  pushl $0
80105b21:	6a 00                	push   $0x0
  pushl $214
80105b23:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105b28:	e9 f4 f2 ff ff       	jmp    80104e21 <alltraps>

80105b2d <vector215>:
.globl vector215
vector215:
  pushl $0
80105b2d:	6a 00                	push   $0x0
  pushl $215
80105b2f:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105b34:	e9 e8 f2 ff ff       	jmp    80104e21 <alltraps>

80105b39 <vector216>:
.globl vector216
vector216:
  pushl $0
80105b39:	6a 00                	push   $0x0
  pushl $216
80105b3b:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105b40:	e9 dc f2 ff ff       	jmp    80104e21 <alltraps>

80105b45 <vector217>:
.globl vector217
vector217:
  pushl $0
80105b45:	6a 00                	push   $0x0
  pushl $217
80105b47:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105b4c:	e9 d0 f2 ff ff       	jmp    80104e21 <alltraps>

80105b51 <vector218>:
.globl vector218
vector218:
  pushl $0
80105b51:	6a 00                	push   $0x0
  pushl $218
80105b53:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105b58:	e9 c4 f2 ff ff       	jmp    80104e21 <alltraps>

80105b5d <vector219>:
.globl vector219
vector219:
  pushl $0
80105b5d:	6a 00                	push   $0x0
  pushl $219
80105b5f:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105b64:	e9 b8 f2 ff ff       	jmp    80104e21 <alltraps>

80105b69 <vector220>:
.globl vector220
vector220:
  pushl $0
80105b69:	6a 00                	push   $0x0
  pushl $220
80105b6b:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105b70:	e9 ac f2 ff ff       	jmp    80104e21 <alltraps>

80105b75 <vector221>:
.globl vector221
vector221:
  pushl $0
80105b75:	6a 00                	push   $0x0
  pushl $221
80105b77:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105b7c:	e9 a0 f2 ff ff       	jmp    80104e21 <alltraps>

80105b81 <vector222>:
.globl vector222
vector222:
  pushl $0
80105b81:	6a 00                	push   $0x0
  pushl $222
80105b83:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105b88:	e9 94 f2 ff ff       	jmp    80104e21 <alltraps>

80105b8d <vector223>:
.globl vector223
vector223:
  pushl $0
80105b8d:	6a 00                	push   $0x0
  pushl $223
80105b8f:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105b94:	e9 88 f2 ff ff       	jmp    80104e21 <alltraps>

80105b99 <vector224>:
.globl vector224
vector224:
  pushl $0
80105b99:	6a 00                	push   $0x0
  pushl $224
80105b9b:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105ba0:	e9 7c f2 ff ff       	jmp    80104e21 <alltraps>

80105ba5 <vector225>:
.globl vector225
vector225:
  pushl $0
80105ba5:	6a 00                	push   $0x0
  pushl $225
80105ba7:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105bac:	e9 70 f2 ff ff       	jmp    80104e21 <alltraps>

80105bb1 <vector226>:
.globl vector226
vector226:
  pushl $0
80105bb1:	6a 00                	push   $0x0
  pushl $226
80105bb3:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105bb8:	e9 64 f2 ff ff       	jmp    80104e21 <alltraps>

80105bbd <vector227>:
.globl vector227
vector227:
  pushl $0
80105bbd:	6a 00                	push   $0x0
  pushl $227
80105bbf:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105bc4:	e9 58 f2 ff ff       	jmp    80104e21 <alltraps>

80105bc9 <vector228>:
.globl vector228
vector228:
  pushl $0
80105bc9:	6a 00                	push   $0x0
  pushl $228
80105bcb:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105bd0:	e9 4c f2 ff ff       	jmp    80104e21 <alltraps>

80105bd5 <vector229>:
.globl vector229
vector229:
  pushl $0
80105bd5:	6a 00                	push   $0x0
  pushl $229
80105bd7:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105bdc:	e9 40 f2 ff ff       	jmp    80104e21 <alltraps>

80105be1 <vector230>:
.globl vector230
vector230:
  pushl $0
80105be1:	6a 00                	push   $0x0
  pushl $230
80105be3:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105be8:	e9 34 f2 ff ff       	jmp    80104e21 <alltraps>

80105bed <vector231>:
.globl vector231
vector231:
  pushl $0
80105bed:	6a 00                	push   $0x0
  pushl $231
80105bef:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105bf4:	e9 28 f2 ff ff       	jmp    80104e21 <alltraps>

80105bf9 <vector232>:
.globl vector232
vector232:
  pushl $0
80105bf9:	6a 00                	push   $0x0
  pushl $232
80105bfb:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105c00:	e9 1c f2 ff ff       	jmp    80104e21 <alltraps>

80105c05 <vector233>:
.globl vector233
vector233:
  pushl $0
80105c05:	6a 00                	push   $0x0
  pushl $233
80105c07:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105c0c:	e9 10 f2 ff ff       	jmp    80104e21 <alltraps>

80105c11 <vector234>:
.globl vector234
vector234:
  pushl $0
80105c11:	6a 00                	push   $0x0
  pushl $234
80105c13:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105c18:	e9 04 f2 ff ff       	jmp    80104e21 <alltraps>

80105c1d <vector235>:
.globl vector235
vector235:
  pushl $0
80105c1d:	6a 00                	push   $0x0
  pushl $235
80105c1f:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105c24:	e9 f8 f1 ff ff       	jmp    80104e21 <alltraps>

80105c29 <vector236>:
.globl vector236
vector236:
  pushl $0
80105c29:	6a 00                	push   $0x0
  pushl $236
80105c2b:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105c30:	e9 ec f1 ff ff       	jmp    80104e21 <alltraps>

80105c35 <vector237>:
.globl vector237
vector237:
  pushl $0
80105c35:	6a 00                	push   $0x0
  pushl $237
80105c37:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105c3c:	e9 e0 f1 ff ff       	jmp    80104e21 <alltraps>

80105c41 <vector238>:
.globl vector238
vector238:
  pushl $0
80105c41:	6a 00                	push   $0x0
  pushl $238
80105c43:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105c48:	e9 d4 f1 ff ff       	jmp    80104e21 <alltraps>

80105c4d <vector239>:
.globl vector239
vector239:
  pushl $0
80105c4d:	6a 00                	push   $0x0
  pushl $239
80105c4f:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105c54:	e9 c8 f1 ff ff       	jmp    80104e21 <alltraps>

80105c59 <vector240>:
.globl vector240
vector240:
  pushl $0
80105c59:	6a 00                	push   $0x0
  pushl $240
80105c5b:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105c60:	e9 bc f1 ff ff       	jmp    80104e21 <alltraps>

80105c65 <vector241>:
.globl vector241
vector241:
  pushl $0
80105c65:	6a 00                	push   $0x0
  pushl $241
80105c67:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105c6c:	e9 b0 f1 ff ff       	jmp    80104e21 <alltraps>

80105c71 <vector242>:
.globl vector242
vector242:
  pushl $0
80105c71:	6a 00                	push   $0x0
  pushl $242
80105c73:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105c78:	e9 a4 f1 ff ff       	jmp    80104e21 <alltraps>

80105c7d <vector243>:
.globl vector243
vector243:
  pushl $0
80105c7d:	6a 00                	push   $0x0
  pushl $243
80105c7f:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105c84:	e9 98 f1 ff ff       	jmp    80104e21 <alltraps>

80105c89 <vector244>:
.globl vector244
vector244:
  pushl $0
80105c89:	6a 00                	push   $0x0
  pushl $244
80105c8b:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105c90:	e9 8c f1 ff ff       	jmp    80104e21 <alltraps>

80105c95 <vector245>:
.globl vector245
vector245:
  pushl $0
80105c95:	6a 00                	push   $0x0
  pushl $245
80105c97:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105c9c:	e9 80 f1 ff ff       	jmp    80104e21 <alltraps>

80105ca1 <vector246>:
.globl vector246
vector246:
  pushl $0
80105ca1:	6a 00                	push   $0x0
  pushl $246
80105ca3:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105ca8:	e9 74 f1 ff ff       	jmp    80104e21 <alltraps>

80105cad <vector247>:
.globl vector247
vector247:
  pushl $0
80105cad:	6a 00                	push   $0x0
  pushl $247
80105caf:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105cb4:	e9 68 f1 ff ff       	jmp    80104e21 <alltraps>

80105cb9 <vector248>:
.globl vector248
vector248:
  pushl $0
80105cb9:	6a 00                	push   $0x0
  pushl $248
80105cbb:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105cc0:	e9 5c f1 ff ff       	jmp    80104e21 <alltraps>

80105cc5 <vector249>:
.globl vector249
vector249:
  pushl $0
80105cc5:	6a 00                	push   $0x0
  pushl $249
80105cc7:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105ccc:	e9 50 f1 ff ff       	jmp    80104e21 <alltraps>

80105cd1 <vector250>:
.globl vector250
vector250:
  pushl $0
80105cd1:	6a 00                	push   $0x0
  pushl $250
80105cd3:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105cd8:	e9 44 f1 ff ff       	jmp    80104e21 <alltraps>

80105cdd <vector251>:
.globl vector251
vector251:
  pushl $0
80105cdd:	6a 00                	push   $0x0
  pushl $251
80105cdf:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105ce4:	e9 38 f1 ff ff       	jmp    80104e21 <alltraps>

80105ce9 <vector252>:
.globl vector252
vector252:
  pushl $0
80105ce9:	6a 00                	push   $0x0
  pushl $252
80105ceb:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105cf0:	e9 2c f1 ff ff       	jmp    80104e21 <alltraps>

80105cf5 <vector253>:
.globl vector253
vector253:
  pushl $0
80105cf5:	6a 00                	push   $0x0
  pushl $253
80105cf7:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105cfc:	e9 20 f1 ff ff       	jmp    80104e21 <alltraps>

80105d01 <vector254>:
.globl vector254
vector254:
  pushl $0
80105d01:	6a 00                	push   $0x0
  pushl $254
80105d03:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105d08:	e9 14 f1 ff ff       	jmp    80104e21 <alltraps>

80105d0d <vector255>:
.globl vector255
vector255:
  pushl $0
80105d0d:	6a 00                	push   $0x0
  pushl $255
80105d0f:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105d14:	e9 08 f1 ff ff       	jmp    80104e21 <alltraps>

80105d19 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105d19:	55                   	push   %ebp
80105d1a:	89 e5                	mov    %esp,%ebp
80105d1c:	57                   	push   %edi
80105d1d:	56                   	push   %esi
80105d1e:	53                   	push   %ebx
80105d1f:	83 ec 0c             	sub    $0xc,%esp
80105d22:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105d24:	c1 ea 16             	shr    $0x16,%edx
80105d27:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105d2a:	8b 37                	mov    (%edi),%esi
80105d2c:	f7 c6 01 00 00 00    	test   $0x1,%esi
80105d32:	74 20                	je     80105d54 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105d34:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105d3a:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105d40:	c1 eb 0c             	shr    $0xc,%ebx
80105d43:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80105d49:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
80105d4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d4f:	5b                   	pop    %ebx
80105d50:	5e                   	pop    %esi
80105d51:	5f                   	pop    %edi
80105d52:	5d                   	pop    %ebp
80105d53:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105d54:	85 c9                	test   %ecx,%ecx
80105d56:	74 2b                	je     80105d83 <walkpgdir+0x6a>
80105d58:	e8 46 c3 ff ff       	call   801020a3 <kalloc>
80105d5d:	89 c6                	mov    %eax,%esi
80105d5f:	85 c0                	test   %eax,%eax
80105d61:	74 20                	je     80105d83 <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
80105d63:	83 ec 04             	sub    $0x4,%esp
80105d66:	68 00 10 00 00       	push   $0x1000
80105d6b:	6a 00                	push   $0x0
80105d6d:	50                   	push   %eax
80105d6e:	e8 fa df ff ff       	call   80103d6d <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105d73:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80105d79:	83 c8 07             	or     $0x7,%eax
80105d7c:	89 07                	mov    %eax,(%edi)
80105d7e:	83 c4 10             	add    $0x10,%esp
80105d81:	eb bd                	jmp    80105d40 <walkpgdir+0x27>
      return 0;
80105d83:	b8 00 00 00 00       	mov    $0x0,%eax
80105d88:	eb c2                	jmp    80105d4c <walkpgdir+0x33>

80105d8a <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105d8a:	55                   	push   %ebp
80105d8b:	89 e5                	mov    %esp,%ebp
80105d8d:	57                   	push   %edi
80105d8e:	56                   	push   %esi
80105d8f:	53                   	push   %ebx
80105d90:	83 ec 1c             	sub    $0x1c,%esp
80105d93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105d96:	8b 75 08             	mov    0x8(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105d99:	89 d3                	mov    %edx,%ebx
80105d9b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105da1:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
80105da5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105dab:	b9 01 00 00 00       	mov    $0x1,%ecx
80105db0:	89 da                	mov    %ebx,%edx
80105db2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105db5:	e8 5f ff ff ff       	call   80105d19 <walkpgdir>
80105dba:	85 c0                	test   %eax,%eax
80105dbc:	74 2e                	je     80105dec <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
80105dbe:	f6 00 01             	testb  $0x1,(%eax)
80105dc1:	75 1c                	jne    80105ddf <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
80105dc3:	89 f2                	mov    %esi,%edx
80105dc5:	0b 55 0c             	or     0xc(%ebp),%edx
80105dc8:	83 ca 01             	or     $0x1,%edx
80105dcb:	89 10                	mov    %edx,(%eax)
    if(a == last)
80105dcd:	39 fb                	cmp    %edi,%ebx
80105dcf:	74 28                	je     80105df9 <mappages+0x6f>
      break;
    a += PGSIZE;
80105dd1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
80105dd7:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105ddd:	eb cc                	jmp    80105dab <mappages+0x21>
      panic("remap");
80105ddf:	83 ec 0c             	sub    $0xc,%esp
80105de2:	68 d8 6f 10 80       	push   $0x80106fd8
80105de7:	e8 5c a5 ff ff       	call   80100348 <panic>
      return -1;
80105dec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80105df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105df4:	5b                   	pop    %ebx
80105df5:	5e                   	pop    %esi
80105df6:	5f                   	pop    %edi
80105df7:	5d                   	pop    %ebp
80105df8:	c3                   	ret    
  return 0;
80105df9:	b8 00 00 00 00       	mov    $0x0,%eax
80105dfe:	eb f1                	jmp    80105df1 <mappages+0x67>

80105e00 <seginit>:
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	57                   	push   %edi
80105e04:	56                   	push   %esi
80105e05:	53                   	push   %ebx
80105e06:	83 ec 1c             	sub    $0x1c,%esp
  c = &cpus[cpuid()];
80105e09:	e8 99 d3 ff ff       	call   801031a7 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105e0e:	69 f8 b0 00 00 00    	imul   $0xb0,%eax,%edi
80105e14:	66 c7 87 18 18 11 80 	movw   $0xffff,-0x7feee7e8(%edi)
80105e1b:	ff ff 
80105e1d:	66 c7 87 1a 18 11 80 	movw   $0x0,-0x7feee7e6(%edi)
80105e24:	00 00 
80105e26:	c6 87 1c 18 11 80 00 	movb   $0x0,-0x7feee7e4(%edi)
80105e2d:	0f b6 8f 1d 18 11 80 	movzbl -0x7feee7e3(%edi),%ecx
80105e34:	83 e1 f0             	and    $0xfffffff0,%ecx
80105e37:	89 ce                	mov    %ecx,%esi
80105e39:	83 ce 0a             	or     $0xa,%esi
80105e3c:	89 f2                	mov    %esi,%edx
80105e3e:	88 97 1d 18 11 80    	mov    %dl,-0x7feee7e3(%edi)
80105e44:	83 c9 1a             	or     $0x1a,%ecx
80105e47:	88 8f 1d 18 11 80    	mov    %cl,-0x7feee7e3(%edi)
80105e4d:	83 e1 9f             	and    $0xffffff9f,%ecx
80105e50:	88 8f 1d 18 11 80    	mov    %cl,-0x7feee7e3(%edi)
80105e56:	83 c9 80             	or     $0xffffff80,%ecx
80105e59:	88 8f 1d 18 11 80    	mov    %cl,-0x7feee7e3(%edi)
80105e5f:	0f b6 8f 1e 18 11 80 	movzbl -0x7feee7e2(%edi),%ecx
80105e66:	83 c9 0f             	or     $0xf,%ecx
80105e69:	88 8f 1e 18 11 80    	mov    %cl,-0x7feee7e2(%edi)
80105e6f:	89 ce                	mov    %ecx,%esi
80105e71:	83 e6 ef             	and    $0xffffffef,%esi
80105e74:	89 f2                	mov    %esi,%edx
80105e76:	88 97 1e 18 11 80    	mov    %dl,-0x7feee7e2(%edi)
80105e7c:	83 e1 cf             	and    $0xffffffcf,%ecx
80105e7f:	88 8f 1e 18 11 80    	mov    %cl,-0x7feee7e2(%edi)
80105e85:	89 ce                	mov    %ecx,%esi
80105e87:	83 ce 40             	or     $0x40,%esi
80105e8a:	89 f2                	mov    %esi,%edx
80105e8c:	88 97 1e 18 11 80    	mov    %dl,-0x7feee7e2(%edi)
80105e92:	83 c9 c0             	or     $0xffffffc0,%ecx
80105e95:	88 8f 1e 18 11 80    	mov    %cl,-0x7feee7e2(%edi)
80105e9b:	c6 87 1f 18 11 80 00 	movb   $0x0,-0x7feee7e1(%edi)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105ea2:	66 c7 87 20 18 11 80 	movw   $0xffff,-0x7feee7e0(%edi)
80105ea9:	ff ff 
80105eab:	66 c7 87 22 18 11 80 	movw   $0x0,-0x7feee7de(%edi)
80105eb2:	00 00 
80105eb4:	c6 87 24 18 11 80 00 	movb   $0x0,-0x7feee7dc(%edi)
80105ebb:	0f b6 8f 25 18 11 80 	movzbl -0x7feee7db(%edi),%ecx
80105ec2:	83 e1 f0             	and    $0xfffffff0,%ecx
80105ec5:	89 ce                	mov    %ecx,%esi
80105ec7:	83 ce 02             	or     $0x2,%esi
80105eca:	89 f2                	mov    %esi,%edx
80105ecc:	88 97 25 18 11 80    	mov    %dl,-0x7feee7db(%edi)
80105ed2:	83 c9 12             	or     $0x12,%ecx
80105ed5:	88 8f 25 18 11 80    	mov    %cl,-0x7feee7db(%edi)
80105edb:	83 e1 9f             	and    $0xffffff9f,%ecx
80105ede:	88 8f 25 18 11 80    	mov    %cl,-0x7feee7db(%edi)
80105ee4:	83 c9 80             	or     $0xffffff80,%ecx
80105ee7:	88 8f 25 18 11 80    	mov    %cl,-0x7feee7db(%edi)
80105eed:	0f b6 8f 26 18 11 80 	movzbl -0x7feee7da(%edi),%ecx
80105ef4:	83 c9 0f             	or     $0xf,%ecx
80105ef7:	88 8f 26 18 11 80    	mov    %cl,-0x7feee7da(%edi)
80105efd:	89 ce                	mov    %ecx,%esi
80105eff:	83 e6 ef             	and    $0xffffffef,%esi
80105f02:	89 f2                	mov    %esi,%edx
80105f04:	88 97 26 18 11 80    	mov    %dl,-0x7feee7da(%edi)
80105f0a:	83 e1 cf             	and    $0xffffffcf,%ecx
80105f0d:	88 8f 26 18 11 80    	mov    %cl,-0x7feee7da(%edi)
80105f13:	89 ce                	mov    %ecx,%esi
80105f15:	83 ce 40             	or     $0x40,%esi
80105f18:	89 f2                	mov    %esi,%edx
80105f1a:	88 97 26 18 11 80    	mov    %dl,-0x7feee7da(%edi)
80105f20:	83 c9 c0             	or     $0xffffffc0,%ecx
80105f23:	88 8f 26 18 11 80    	mov    %cl,-0x7feee7da(%edi)
80105f29:	c6 87 27 18 11 80 00 	movb   $0x0,-0x7feee7d9(%edi)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105f30:	66 c7 87 28 18 11 80 	movw   $0xffff,-0x7feee7d8(%edi)
80105f37:	ff ff 
80105f39:	66 c7 87 2a 18 11 80 	movw   $0x0,-0x7feee7d6(%edi)
80105f40:	00 00 
80105f42:	c6 87 2c 18 11 80 00 	movb   $0x0,-0x7feee7d4(%edi)
80105f49:	0f b6 9f 2d 18 11 80 	movzbl -0x7feee7d3(%edi),%ebx
80105f50:	83 e3 f0             	and    $0xfffffff0,%ebx
80105f53:	89 de                	mov    %ebx,%esi
80105f55:	83 ce 0a             	or     $0xa,%esi
80105f58:	89 f2                	mov    %esi,%edx
80105f5a:	88 97 2d 18 11 80    	mov    %dl,-0x7feee7d3(%edi)
80105f60:	89 de                	mov    %ebx,%esi
80105f62:	83 ce 1a             	or     $0x1a,%esi
80105f65:	89 f2                	mov    %esi,%edx
80105f67:	88 97 2d 18 11 80    	mov    %dl,-0x7feee7d3(%edi)
80105f6d:	83 cb 7a             	or     $0x7a,%ebx
80105f70:	88 9f 2d 18 11 80    	mov    %bl,-0x7feee7d3(%edi)
80105f76:	c6 87 2d 18 11 80 fa 	movb   $0xfa,-0x7feee7d3(%edi)
80105f7d:	0f b6 9f 2e 18 11 80 	movzbl -0x7feee7d2(%edi),%ebx
80105f84:	83 cb 0f             	or     $0xf,%ebx
80105f87:	88 9f 2e 18 11 80    	mov    %bl,-0x7feee7d2(%edi)
80105f8d:	89 de                	mov    %ebx,%esi
80105f8f:	83 e6 ef             	and    $0xffffffef,%esi
80105f92:	89 f2                	mov    %esi,%edx
80105f94:	88 97 2e 18 11 80    	mov    %dl,-0x7feee7d2(%edi)
80105f9a:	83 e3 cf             	and    $0xffffffcf,%ebx
80105f9d:	88 9f 2e 18 11 80    	mov    %bl,-0x7feee7d2(%edi)
80105fa3:	89 de                	mov    %ebx,%esi
80105fa5:	83 ce 40             	or     $0x40,%esi
80105fa8:	89 f2                	mov    %esi,%edx
80105faa:	88 97 2e 18 11 80    	mov    %dl,-0x7feee7d2(%edi)
80105fb0:	83 cb c0             	or     $0xffffffc0,%ebx
80105fb3:	88 9f 2e 18 11 80    	mov    %bl,-0x7feee7d2(%edi)
80105fb9:	c6 87 2f 18 11 80 00 	movb   $0x0,-0x7feee7d1(%edi)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80105fc0:	66 c7 87 30 18 11 80 	movw   $0xffff,-0x7feee7d0(%edi)
80105fc7:	ff ff 
80105fc9:	66 c7 87 32 18 11 80 	movw   $0x0,-0x7feee7ce(%edi)
80105fd0:	00 00 
80105fd2:	c6 87 34 18 11 80 00 	movb   $0x0,-0x7feee7cc(%edi)
80105fd9:	0f b6 9f 35 18 11 80 	movzbl -0x7feee7cb(%edi),%ebx
80105fe0:	83 e3 f0             	and    $0xfffffff0,%ebx
80105fe3:	89 de                	mov    %ebx,%esi
80105fe5:	83 ce 02             	or     $0x2,%esi
80105fe8:	89 f2                	mov    %esi,%edx
80105fea:	88 97 35 18 11 80    	mov    %dl,-0x7feee7cb(%edi)
80105ff0:	89 de                	mov    %ebx,%esi
80105ff2:	83 ce 12             	or     $0x12,%esi
80105ff5:	89 f2                	mov    %esi,%edx
80105ff7:	88 97 35 18 11 80    	mov    %dl,-0x7feee7cb(%edi)
80105ffd:	83 cb 72             	or     $0x72,%ebx
80106000:	88 9f 35 18 11 80    	mov    %bl,-0x7feee7cb(%edi)
80106006:	c6 87 35 18 11 80 f2 	movb   $0xf2,-0x7feee7cb(%edi)
8010600d:	0f b6 9f 36 18 11 80 	movzbl -0x7feee7ca(%edi),%ebx
80106014:	83 cb 0f             	or     $0xf,%ebx
80106017:	88 9f 36 18 11 80    	mov    %bl,-0x7feee7ca(%edi)
8010601d:	89 de                	mov    %ebx,%esi
8010601f:	83 e6 ef             	and    $0xffffffef,%esi
80106022:	89 f2                	mov    %esi,%edx
80106024:	88 97 36 18 11 80    	mov    %dl,-0x7feee7ca(%edi)
8010602a:	83 e3 cf             	and    $0xffffffcf,%ebx
8010602d:	88 9f 36 18 11 80    	mov    %bl,-0x7feee7ca(%edi)
80106033:	89 de                	mov    %ebx,%esi
80106035:	83 ce 40             	or     $0x40,%esi
80106038:	89 f2                	mov    %esi,%edx
8010603a:	88 97 36 18 11 80    	mov    %dl,-0x7feee7ca(%edi)
80106040:	83 cb c0             	or     $0xffffffc0,%ebx
80106043:	88 9f 36 18 11 80    	mov    %bl,-0x7feee7ca(%edi)
80106049:	c6 87 37 18 11 80 00 	movb   $0x0,-0x7feee7c9(%edi)
  lgdt(c->gdt, sizeof(c->gdt));
80106050:	8d 97 10 18 11 80    	lea    -0x7feee7f0(%edi),%edx
  pd[0] = size-1;
80106056:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
8010605c:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
80106060:	c1 ea 10             	shr    $0x10,%edx
80106063:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106067:	8d 45 e2             	lea    -0x1e(%ebp),%eax
8010606a:	0f 01 10             	lgdtl  (%eax)
}
8010606d:	83 c4 1c             	add    $0x1c,%esp
80106070:	5b                   	pop    %ebx
80106071:	5e                   	pop    %esi
80106072:	5f                   	pop    %edi
80106073:	5d                   	pop    %ebp
80106074:	c3                   	ret    

80106075 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106075:	a1 c4 46 11 80       	mov    0x801146c4,%eax
8010607a:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010607f:	0f 22 d8             	mov    %eax,%cr3
}
80106082:	c3                   	ret    

80106083 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106083:	55                   	push   %ebp
80106084:	89 e5                	mov    %esp,%ebp
80106086:	57                   	push   %edi
80106087:	56                   	push   %esi
80106088:	53                   	push   %ebx
80106089:	83 ec 1c             	sub    $0x1c,%esp
8010608c:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010608f:	85 f6                	test   %esi,%esi
80106091:	0f 84 25 01 00 00    	je     801061bc <switchuvm+0x139>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106097:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
8010609b:	0f 84 28 01 00 00    	je     801061c9 <switchuvm+0x146>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801060a1:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
801060a5:	0f 84 2b 01 00 00    	je     801061d6 <switchuvm+0x153>
    panic("switchuvm: no pgdir");

  pushcli();
801060ab:	e8 36 db ff ff       	call   80103be6 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801060b0:	e8 96 d0 ff ff       	call   8010314b <mycpu>
801060b5:	89 c3                	mov    %eax,%ebx
801060b7:	e8 8f d0 ff ff       	call   8010314b <mycpu>
801060bc:	8d 78 08             	lea    0x8(%eax),%edi
801060bf:	e8 87 d0 ff ff       	call   8010314b <mycpu>
801060c4:	83 c0 08             	add    $0x8,%eax
801060c7:	c1 e8 10             	shr    $0x10,%eax
801060ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801060cd:	e8 79 d0 ff ff       	call   8010314b <mycpu>
801060d2:	83 c0 08             	add    $0x8,%eax
801060d5:	c1 e8 18             	shr    $0x18,%eax
801060d8:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801060df:	67 00 
801060e1:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801060e8:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
801060ec:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801060f2:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
801060f9:	83 e2 f0             	and    $0xfffffff0,%edx
801060fc:	89 d1                	mov    %edx,%ecx
801060fe:	83 c9 09             	or     $0x9,%ecx
80106101:	88 8b 9d 00 00 00    	mov    %cl,0x9d(%ebx)
80106107:	83 ca 19             	or     $0x19,%edx
8010610a:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106110:	83 e2 9f             	and    $0xffffff9f,%edx
80106113:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106119:	83 ca 80             	or     $0xffffff80,%edx
8010611c:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106122:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80106129:	89 d1                	mov    %edx,%ecx
8010612b:	83 e1 f0             	and    $0xfffffff0,%ecx
8010612e:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
80106134:	89 d1                	mov    %edx,%ecx
80106136:	83 e1 e0             	and    $0xffffffe0,%ecx
80106139:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
8010613f:	83 e2 c0             	and    $0xffffffc0,%edx
80106142:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106148:	83 ca 40             	or     $0x40,%edx
8010614b:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106151:	83 e2 7f             	and    $0x7f,%edx
80106154:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010615a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106160:	e8 e6 cf ff ff       	call   8010314b <mycpu>
80106165:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010616c:	83 e2 ef             	and    $0xffffffef,%edx
8010616f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106175:	e8 d1 cf ff ff       	call   8010314b <mycpu>
8010617a:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106180:	8b 5e 08             	mov    0x8(%esi),%ebx
80106183:	e8 c3 cf ff ff       	call   8010314b <mycpu>
80106188:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010618e:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106191:	e8 b5 cf ff ff       	call   8010314b <mycpu>
80106196:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
8010619c:	b8 28 00 00 00       	mov    $0x28,%eax
801061a1:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801061a4:	8b 46 04             	mov    0x4(%esi),%eax
801061a7:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801061ac:	0f 22 d8             	mov    %eax,%cr3
  popcli();
801061af:	e8 6e da ff ff       	call   80103c22 <popcli>
}
801061b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061b7:	5b                   	pop    %ebx
801061b8:	5e                   	pop    %esi
801061b9:	5f                   	pop    %edi
801061ba:	5d                   	pop    %ebp
801061bb:	c3                   	ret    
    panic("switchuvm: no process");
801061bc:	83 ec 0c             	sub    $0xc,%esp
801061bf:	68 de 6f 10 80       	push   $0x80106fde
801061c4:	e8 7f a1 ff ff       	call   80100348 <panic>
    panic("switchuvm: no kstack");
801061c9:	83 ec 0c             	sub    $0xc,%esp
801061cc:	68 f4 6f 10 80       	push   $0x80106ff4
801061d1:	e8 72 a1 ff ff       	call   80100348 <panic>
    panic("switchuvm: no pgdir");
801061d6:	83 ec 0c             	sub    $0xc,%esp
801061d9:	68 09 70 10 80       	push   $0x80107009
801061de:	e8 65 a1 ff ff       	call   80100348 <panic>

801061e3 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801061e3:	55                   	push   %ebp
801061e4:	89 e5                	mov    %esp,%ebp
801061e6:	56                   	push   %esi
801061e7:	53                   	push   %ebx
801061e8:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
801061eb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801061f1:	77 4c                	ja     8010623f <inituvm+0x5c>
    panic("inituvm: more than a page");
  mem = kalloc();
801061f3:	e8 ab be ff ff       	call   801020a3 <kalloc>
801061f8:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801061fa:	83 ec 04             	sub    $0x4,%esp
801061fd:	68 00 10 00 00       	push   $0x1000
80106202:	6a 00                	push   $0x0
80106204:	50                   	push   %eax
80106205:	e8 63 db ff ff       	call   80103d6d <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010620a:	83 c4 08             	add    $0x8,%esp
8010620d:	6a 06                	push   $0x6
8010620f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106215:	50                   	push   %eax
80106216:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010621b:	ba 00 00 00 00       	mov    $0x0,%edx
80106220:	8b 45 08             	mov    0x8(%ebp),%eax
80106223:	e8 62 fb ff ff       	call   80105d8a <mappages>
  memmove(mem, init, sz);
80106228:	83 c4 0c             	add    $0xc,%esp
8010622b:	56                   	push   %esi
8010622c:	ff 75 0c             	push   0xc(%ebp)
8010622f:	53                   	push   %ebx
80106230:	e8 b0 db ff ff       	call   80103de5 <memmove>
}
80106235:	83 c4 10             	add    $0x10,%esp
80106238:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010623b:	5b                   	pop    %ebx
8010623c:	5e                   	pop    %esi
8010623d:	5d                   	pop    %ebp
8010623e:	c3                   	ret    
    panic("inituvm: more than a page");
8010623f:	83 ec 0c             	sub    $0xc,%esp
80106242:	68 1d 70 10 80       	push   $0x8010701d
80106247:	e8 fc a0 ff ff       	call   80100348 <panic>

8010624c <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010624c:	55                   	push   %ebp
8010624d:	89 e5                	mov    %esp,%ebp
8010624f:	57                   	push   %edi
80106250:	56                   	push   %esi
80106251:	53                   	push   %ebx
80106252:	83 ec 0c             	sub    $0xc,%esp
80106255:	8b 7d 18             	mov    0x18(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106258:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010625b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106261:	74 3c                	je     8010629f <loaduvm+0x53>
    panic("loaduvm: addr must be page aligned");
80106263:	83 ec 0c             	sub    $0xc,%esp
80106266:	68 d8 70 10 80       	push   $0x801070d8
8010626b:	e8 d8 a0 ff ff       	call   80100348 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106270:	83 ec 0c             	sub    $0xc,%esp
80106273:	68 37 70 10 80       	push   $0x80107037
80106278:	e8 cb a0 ff ff       	call   80100348 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010627d:	05 00 00 00 80       	add    $0x80000000,%eax
80106282:	56                   	push   %esi
80106283:	89 da                	mov    %ebx,%edx
80106285:	03 55 14             	add    0x14(%ebp),%edx
80106288:	52                   	push   %edx
80106289:	50                   	push   %eax
8010628a:	ff 75 10             	push   0x10(%ebp)
8010628d:	e8 cf b4 ff ff       	call   80101761 <readi>
80106292:	83 c4 10             	add    $0x10,%esp
80106295:	39 f0                	cmp    %esi,%eax
80106297:	75 47                	jne    801062e0 <loaduvm+0x94>
  for(i = 0; i < sz; i += PGSIZE){
80106299:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010629f:	39 fb                	cmp    %edi,%ebx
801062a1:	73 30                	jae    801062d3 <loaduvm+0x87>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801062a3:	89 da                	mov    %ebx,%edx
801062a5:	03 55 0c             	add    0xc(%ebp),%edx
801062a8:	b9 00 00 00 00       	mov    $0x0,%ecx
801062ad:	8b 45 08             	mov    0x8(%ebp),%eax
801062b0:	e8 64 fa ff ff       	call   80105d19 <walkpgdir>
801062b5:	85 c0                	test   %eax,%eax
801062b7:	74 b7                	je     80106270 <loaduvm+0x24>
    pa = PTE_ADDR(*pte);
801062b9:	8b 00                	mov    (%eax),%eax
801062bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801062c0:	89 fe                	mov    %edi,%esi
801062c2:	29 de                	sub    %ebx,%esi
801062c4:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801062ca:	76 b1                	jbe    8010627d <loaduvm+0x31>
      n = PGSIZE;
801062cc:	be 00 10 00 00       	mov    $0x1000,%esi
801062d1:	eb aa                	jmp    8010627d <loaduvm+0x31>
      return -1;
  }
  return 0;
801062d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062db:	5b                   	pop    %ebx
801062dc:	5e                   	pop    %esi
801062dd:	5f                   	pop    %edi
801062de:	5d                   	pop    %ebp
801062df:	c3                   	ret    
      return -1;
801062e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e5:	eb f1                	jmp    801062d8 <loaduvm+0x8c>

801062e7 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801062e7:	55                   	push   %ebp
801062e8:	89 e5                	mov    %esp,%ebp
801062ea:	57                   	push   %edi
801062eb:	56                   	push   %esi
801062ec:	53                   	push   %ebx
801062ed:	83 ec 0c             	sub    $0xc,%esp
801062f0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801062f3:	39 7d 10             	cmp    %edi,0x10(%ebp)
801062f6:	73 11                	jae    80106309 <deallocuvm+0x22>
    return oldsz;

  a = PGROUNDUP(newsz);
801062f8:	8b 45 10             	mov    0x10(%ebp),%eax
801062fb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106301:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106307:	eb 19                	jmp    80106322 <deallocuvm+0x3b>
    return oldsz;
80106309:	89 f8                	mov    %edi,%eax
8010630b:	eb 64                	jmp    80106371 <deallocuvm+0x8a>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010630d:	c1 eb 16             	shr    $0x16,%ebx
80106310:	83 c3 01             	add    $0x1,%ebx
80106313:	c1 e3 16             	shl    $0x16,%ebx
80106316:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010631c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106322:	39 fb                	cmp    %edi,%ebx
80106324:	73 48                	jae    8010636e <deallocuvm+0x87>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106326:	b9 00 00 00 00       	mov    $0x0,%ecx
8010632b:	89 da                	mov    %ebx,%edx
8010632d:	8b 45 08             	mov    0x8(%ebp),%eax
80106330:	e8 e4 f9 ff ff       	call   80105d19 <walkpgdir>
80106335:	89 c6                	mov    %eax,%esi
    if(!pte)
80106337:	85 c0                	test   %eax,%eax
80106339:	74 d2                	je     8010630d <deallocuvm+0x26>
    else if((*pte & PTE_P) != 0){
8010633b:	8b 00                	mov    (%eax),%eax
8010633d:	a8 01                	test   $0x1,%al
8010633f:	74 db                	je     8010631c <deallocuvm+0x35>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106341:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106346:	74 19                	je     80106361 <deallocuvm+0x7a>
        panic("kfree");
      char *v = P2V(pa);
80106348:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010634d:	83 ec 0c             	sub    $0xc,%esp
80106350:	50                   	push   %eax
80106351:	e8 36 bc ff ff       	call   80101f8c <kfree>
      *pte = 0;
80106356:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010635c:	83 c4 10             	add    $0x10,%esp
8010635f:	eb bb                	jmp    8010631c <deallocuvm+0x35>
        panic("kfree");
80106361:	83 ec 0c             	sub    $0xc,%esp
80106364:	68 86 69 10 80       	push   $0x80106986
80106369:	e8 da 9f ff ff       	call   80100348 <panic>
    }
  }
  return newsz;
8010636e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80106371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106374:	5b                   	pop    %ebx
80106375:	5e                   	pop    %esi
80106376:	5f                   	pop    %edi
80106377:	5d                   	pop    %ebp
80106378:	c3                   	ret    

80106379 <allocuvm>:
{
80106379:	55                   	push   %ebp
8010637a:	89 e5                	mov    %esp,%ebp
8010637c:	57                   	push   %edi
8010637d:	56                   	push   %esi
8010637e:	53                   	push   %ebx
8010637f:	83 ec 1c             	sub    $0x1c,%esp
80106382:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106385:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106388:	85 ff                	test   %edi,%edi
8010638a:	0f 88 c1 00 00 00    	js     80106451 <allocuvm+0xd8>
  if(newsz < oldsz)
80106390:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106393:	72 5c                	jb     801063f1 <allocuvm+0x78>
  a = PGROUNDUP(oldsz);
80106395:	8b 45 0c             	mov    0xc(%ebp),%eax
80106398:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010639e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801063a4:	39 fe                	cmp    %edi,%esi
801063a6:	0f 83 ac 00 00 00    	jae    80106458 <allocuvm+0xdf>
    mem = kalloc();
801063ac:	e8 f2 bc ff ff       	call   801020a3 <kalloc>
801063b1:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801063b3:	85 c0                	test   %eax,%eax
801063b5:	74 42                	je     801063f9 <allocuvm+0x80>
    memset(mem, 0, PGSIZE);
801063b7:	83 ec 04             	sub    $0x4,%esp
801063ba:	68 00 10 00 00       	push   $0x1000
801063bf:	6a 00                	push   $0x0
801063c1:	50                   	push   %eax
801063c2:	e8 a6 d9 ff ff       	call   80103d6d <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801063c7:	83 c4 08             	add    $0x8,%esp
801063ca:	6a 06                	push   $0x6
801063cc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801063d2:	50                   	push   %eax
801063d3:	b9 00 10 00 00       	mov    $0x1000,%ecx
801063d8:	89 f2                	mov    %esi,%edx
801063da:	8b 45 08             	mov    0x8(%ebp),%eax
801063dd:	e8 a8 f9 ff ff       	call   80105d8a <mappages>
801063e2:	83 c4 10             	add    $0x10,%esp
801063e5:	85 c0                	test   %eax,%eax
801063e7:	78 38                	js     80106421 <allocuvm+0xa8>
  for(; a < newsz; a += PGSIZE){
801063e9:	81 c6 00 10 00 00    	add    $0x1000,%esi
801063ef:	eb b3                	jmp    801063a4 <allocuvm+0x2b>
    return oldsz;
801063f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801063f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801063f7:	eb 5f                	jmp    80106458 <allocuvm+0xdf>
      cprintf("allocuvm out of memory\n");
801063f9:	83 ec 0c             	sub    $0xc,%esp
801063fc:	68 55 70 10 80       	push   $0x80107055
80106401:	e8 01 a2 ff ff       	call   80100607 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106406:	83 c4 0c             	add    $0xc,%esp
80106409:	ff 75 0c             	push   0xc(%ebp)
8010640c:	57                   	push   %edi
8010640d:	ff 75 08             	push   0x8(%ebp)
80106410:	e8 d2 fe ff ff       	call   801062e7 <deallocuvm>
      return 0;
80106415:	83 c4 10             	add    $0x10,%esp
80106418:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010641f:	eb 37                	jmp    80106458 <allocuvm+0xdf>
      cprintf("allocuvm out of memory (2)\n");
80106421:	83 ec 0c             	sub    $0xc,%esp
80106424:	68 6d 70 10 80       	push   $0x8010706d
80106429:	e8 d9 a1 ff ff       	call   80100607 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010642e:	83 c4 0c             	add    $0xc,%esp
80106431:	ff 75 0c             	push   0xc(%ebp)
80106434:	57                   	push   %edi
80106435:	ff 75 08             	push   0x8(%ebp)
80106438:	e8 aa fe ff ff       	call   801062e7 <deallocuvm>
      kfree(mem);
8010643d:	89 1c 24             	mov    %ebx,(%esp)
80106440:	e8 47 bb ff ff       	call   80101f8c <kfree>
      return 0;
80106445:	83 c4 10             	add    $0x10,%esp
80106448:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010644f:	eb 07                	jmp    80106458 <allocuvm+0xdf>
    return 0;
80106451:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106458:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010645b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010645e:	5b                   	pop    %ebx
8010645f:	5e                   	pop    %esi
80106460:	5f                   	pop    %edi
80106461:	5d                   	pop    %ebp
80106462:	c3                   	ret    

80106463 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106463:	55                   	push   %ebp
80106464:	89 e5                	mov    %esp,%ebp
80106466:	56                   	push   %esi
80106467:	53                   	push   %ebx
80106468:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010646b:	85 f6                	test   %esi,%esi
8010646d:	74 1a                	je     80106489 <freevm+0x26>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
8010646f:	83 ec 04             	sub    $0x4,%esp
80106472:	6a 00                	push   $0x0
80106474:	68 00 00 00 80       	push   $0x80000000
80106479:	56                   	push   %esi
8010647a:	e8 68 fe ff ff       	call   801062e7 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010647f:	83 c4 10             	add    $0x10,%esp
80106482:	bb 00 00 00 00       	mov    $0x0,%ebx
80106487:	eb 10                	jmp    80106499 <freevm+0x36>
    panic("freevm: no pgdir");
80106489:	83 ec 0c             	sub    $0xc,%esp
8010648c:	68 89 70 10 80       	push   $0x80107089
80106491:	e8 b2 9e ff ff       	call   80100348 <panic>
  for(i = 0; i < NPDENTRIES; i++){
80106496:	83 c3 01             	add    $0x1,%ebx
80106499:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
8010649f:	77 1f                	ja     801064c0 <freevm+0x5d>
    if(pgdir[i] & PTE_P){
801064a1:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
801064a4:	a8 01                	test   $0x1,%al
801064a6:	74 ee                	je     80106496 <freevm+0x33>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801064a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801064ad:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801064b2:	83 ec 0c             	sub    $0xc,%esp
801064b5:	50                   	push   %eax
801064b6:	e8 d1 ba ff ff       	call   80101f8c <kfree>
801064bb:	83 c4 10             	add    $0x10,%esp
801064be:	eb d6                	jmp    80106496 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
801064c0:	83 ec 0c             	sub    $0xc,%esp
801064c3:	56                   	push   %esi
801064c4:	e8 c3 ba ff ff       	call   80101f8c <kfree>
}
801064c9:	83 c4 10             	add    $0x10,%esp
801064cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801064cf:	5b                   	pop    %ebx
801064d0:	5e                   	pop    %esi
801064d1:	5d                   	pop    %ebp
801064d2:	c3                   	ret    

801064d3 <setupkvm>:
{
801064d3:	55                   	push   %ebp
801064d4:	89 e5                	mov    %esp,%ebp
801064d6:	56                   	push   %esi
801064d7:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801064d8:	e8 c6 bb ff ff       	call   801020a3 <kalloc>
801064dd:	89 c6                	mov    %eax,%esi
801064df:	85 c0                	test   %eax,%eax
801064e1:	74 55                	je     80106538 <setupkvm+0x65>
  memset(pgdir, 0, PGSIZE);
801064e3:	83 ec 04             	sub    $0x4,%esp
801064e6:	68 00 10 00 00       	push   $0x1000
801064eb:	6a 00                	push   $0x0
801064ed:	50                   	push   %eax
801064ee:	e8 7a d8 ff ff       	call   80103d6d <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801064f3:	83 c4 10             	add    $0x10,%esp
801064f6:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
801064fb:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106501:	73 35                	jae    80106538 <setupkvm+0x65>
                (uint)k->phys_start, k->perm) < 0) {
80106503:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106506:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106509:	29 c1                	sub    %eax,%ecx
8010650b:	83 ec 08             	sub    $0x8,%esp
8010650e:	ff 73 0c             	push   0xc(%ebx)
80106511:	50                   	push   %eax
80106512:	8b 13                	mov    (%ebx),%edx
80106514:	89 f0                	mov    %esi,%eax
80106516:	e8 6f f8 ff ff       	call   80105d8a <mappages>
8010651b:	83 c4 10             	add    $0x10,%esp
8010651e:	85 c0                	test   %eax,%eax
80106520:	78 05                	js     80106527 <setupkvm+0x54>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106522:	83 c3 10             	add    $0x10,%ebx
80106525:	eb d4                	jmp    801064fb <setupkvm+0x28>
      freevm(pgdir);
80106527:	83 ec 0c             	sub    $0xc,%esp
8010652a:	56                   	push   %esi
8010652b:	e8 33 ff ff ff       	call   80106463 <freevm>
      return 0;
80106530:	83 c4 10             	add    $0x10,%esp
80106533:	be 00 00 00 00       	mov    $0x0,%esi
}
80106538:	89 f0                	mov    %esi,%eax
8010653a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010653d:	5b                   	pop    %ebx
8010653e:	5e                   	pop    %esi
8010653f:	5d                   	pop    %ebp
80106540:	c3                   	ret    

80106541 <kvmalloc>:
{
80106541:	55                   	push   %ebp
80106542:	89 e5                	mov    %esp,%ebp
80106544:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106547:	e8 87 ff ff ff       	call   801064d3 <setupkvm>
8010654c:	a3 c4 46 11 80       	mov    %eax,0x801146c4
  switchkvm();
80106551:	e8 1f fb ff ff       	call   80106075 <switchkvm>
}
80106556:	c9                   	leave  
80106557:	c3                   	ret    

80106558 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106558:	55                   	push   %ebp
80106559:	89 e5                	mov    %esp,%ebp
8010655b:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010655e:	b9 00 00 00 00       	mov    $0x0,%ecx
80106563:	8b 55 0c             	mov    0xc(%ebp),%edx
80106566:	8b 45 08             	mov    0x8(%ebp),%eax
80106569:	e8 ab f7 ff ff       	call   80105d19 <walkpgdir>
  if(pte == 0)
8010656e:	85 c0                	test   %eax,%eax
80106570:	74 05                	je     80106577 <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106572:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106575:	c9                   	leave  
80106576:	c3                   	ret    
    panic("clearpteu");
80106577:	83 ec 0c             	sub    $0xc,%esp
8010657a:	68 9a 70 10 80       	push   $0x8010709a
8010657f:	e8 c4 9d ff ff       	call   80100348 <panic>

80106584 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106584:	55                   	push   %ebp
80106585:	89 e5                	mov    %esp,%ebp
80106587:	57                   	push   %edi
80106588:	56                   	push   %esi
80106589:	53                   	push   %ebx
8010658a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010658d:	e8 41 ff ff ff       	call   801064d3 <setupkvm>
80106592:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106595:	85 c0                	test   %eax,%eax
80106597:	0f 84 c4 00 00 00    	je     80106661 <copyuvm+0xdd>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010659d:	bf 00 00 00 00       	mov    $0x0,%edi
801065a2:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801065a5:	0f 83 b6 00 00 00    	jae    80106661 <copyuvm+0xdd>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801065ab:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801065ae:	b9 00 00 00 00       	mov    $0x0,%ecx
801065b3:	89 fa                	mov    %edi,%edx
801065b5:	8b 45 08             	mov    0x8(%ebp),%eax
801065b8:	e8 5c f7 ff ff       	call   80105d19 <walkpgdir>
801065bd:	85 c0                	test   %eax,%eax
801065bf:	74 65                	je     80106626 <copyuvm+0xa2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801065c1:	8b 00                	mov    (%eax),%eax
801065c3:	a8 01                	test   $0x1,%al
801065c5:	74 6c                	je     80106633 <copyuvm+0xaf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801065c7:	89 c6                	mov    %eax,%esi
801065c9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
801065cf:	25 ff 0f 00 00       	and    $0xfff,%eax
801065d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
801065d7:	e8 c7 ba ff ff       	call   801020a3 <kalloc>
801065dc:	89 c3                	mov    %eax,%ebx
801065de:	85 c0                	test   %eax,%eax
801065e0:	74 6a                	je     8010664c <copyuvm+0xc8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801065e2:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801065e8:	83 ec 04             	sub    $0x4,%esp
801065eb:	68 00 10 00 00       	push   $0x1000
801065f0:	56                   	push   %esi
801065f1:	50                   	push   %eax
801065f2:	e8 ee d7 ff ff       	call   80103de5 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801065f7:	83 c4 08             	add    $0x8,%esp
801065fa:	ff 75 e0             	push   -0x20(%ebp)
801065fd:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106603:	50                   	push   %eax
80106604:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106609:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010660c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010660f:	e8 76 f7 ff ff       	call   80105d8a <mappages>
80106614:	83 c4 10             	add    $0x10,%esp
80106617:	85 c0                	test   %eax,%eax
80106619:	78 25                	js     80106640 <copyuvm+0xbc>
  for(i = 0; i < sz; i += PGSIZE){
8010661b:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106621:	e9 7c ff ff ff       	jmp    801065a2 <copyuvm+0x1e>
      panic("copyuvm: pte should exist");
80106626:	83 ec 0c             	sub    $0xc,%esp
80106629:	68 a4 70 10 80       	push   $0x801070a4
8010662e:	e8 15 9d ff ff       	call   80100348 <panic>
      panic("copyuvm: page not present");
80106633:	83 ec 0c             	sub    $0xc,%esp
80106636:	68 be 70 10 80       	push   $0x801070be
8010663b:	e8 08 9d ff ff       	call   80100348 <panic>
      kfree(mem);
80106640:	83 ec 0c             	sub    $0xc,%esp
80106643:	53                   	push   %ebx
80106644:	e8 43 b9 ff ff       	call   80101f8c <kfree>
      goto bad;
80106649:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d);
8010664c:	83 ec 0c             	sub    $0xc,%esp
8010664f:	ff 75 dc             	push   -0x24(%ebp)
80106652:	e8 0c fe ff ff       	call   80106463 <freevm>
  return 0;
80106657:	83 c4 10             	add    $0x10,%esp
8010665a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80106661:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106664:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106667:	5b                   	pop    %ebx
80106668:	5e                   	pop    %esi
80106669:	5f                   	pop    %edi
8010666a:	5d                   	pop    %ebp
8010666b:	c3                   	ret    

8010666c <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010666c:	55                   	push   %ebp
8010666d:	89 e5                	mov    %esp,%ebp
8010666f:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106672:	b9 00 00 00 00       	mov    $0x0,%ecx
80106677:	8b 55 0c             	mov    0xc(%ebp),%edx
8010667a:	8b 45 08             	mov    0x8(%ebp),%eax
8010667d:	e8 97 f6 ff ff       	call   80105d19 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106682:	8b 00                	mov    (%eax),%eax
80106684:	a8 01                	test   $0x1,%al
80106686:	74 10                	je     80106698 <uva2ka+0x2c>
    return 0;
  if((*pte & PTE_U) == 0)
80106688:	a8 04                	test   $0x4,%al
8010668a:	74 13                	je     8010669f <uva2ka+0x33>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010668c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106691:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106696:	c9                   	leave  
80106697:	c3                   	ret    
    return 0;
80106698:	b8 00 00 00 00       	mov    $0x0,%eax
8010669d:	eb f7                	jmp    80106696 <uva2ka+0x2a>
    return 0;
8010669f:	b8 00 00 00 00       	mov    $0x0,%eax
801066a4:	eb f0                	jmp    80106696 <uva2ka+0x2a>

801066a6 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801066a6:	55                   	push   %ebp
801066a7:	89 e5                	mov    %esp,%ebp
801066a9:	57                   	push   %edi
801066aa:	56                   	push   %esi
801066ab:	53                   	push   %ebx
801066ac:	83 ec 0c             	sub    $0xc,%esp
801066af:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801066b2:	eb 25                	jmp    801066d9 <copyout+0x33>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801066b4:	8b 55 0c             	mov    0xc(%ebp),%edx
801066b7:	29 f2                	sub    %esi,%edx
801066b9:	01 d0                	add    %edx,%eax
801066bb:	83 ec 04             	sub    $0x4,%esp
801066be:	53                   	push   %ebx
801066bf:	ff 75 10             	push   0x10(%ebp)
801066c2:	50                   	push   %eax
801066c3:	e8 1d d7 ff ff       	call   80103de5 <memmove>
    len -= n;
801066c8:	29 df                	sub    %ebx,%edi
    buf += n;
801066ca:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801066cd:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
801066d3:	89 45 0c             	mov    %eax,0xc(%ebp)
801066d6:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
801066d9:	85 ff                	test   %edi,%edi
801066db:	74 2f                	je     8010670c <copyout+0x66>
    va0 = (uint)PGROUNDDOWN(va);
801066dd:	8b 75 0c             	mov    0xc(%ebp),%esi
801066e0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801066e6:	83 ec 08             	sub    $0x8,%esp
801066e9:	56                   	push   %esi
801066ea:	ff 75 08             	push   0x8(%ebp)
801066ed:	e8 7a ff ff ff       	call   8010666c <uva2ka>
    if(pa0 == 0)
801066f2:	83 c4 10             	add    $0x10,%esp
801066f5:	85 c0                	test   %eax,%eax
801066f7:	74 20                	je     80106719 <copyout+0x73>
    n = PGSIZE - (va - va0);
801066f9:	89 f3                	mov    %esi,%ebx
801066fb:	2b 5d 0c             	sub    0xc(%ebp),%ebx
801066fe:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106704:	39 df                	cmp    %ebx,%edi
80106706:	73 ac                	jae    801066b4 <copyout+0xe>
      n = len;
80106708:	89 fb                	mov    %edi,%ebx
8010670a:	eb a8                	jmp    801066b4 <copyout+0xe>
  }
  return 0;
8010670c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106714:	5b                   	pop    %ebx
80106715:	5e                   	pop    %esi
80106716:	5f                   	pop    %edi
80106717:	5d                   	pop    %ebp
80106718:	c3                   	ret    
      return -1;
80106719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671e:	eb f1                	jmp    80106711 <copyout+0x6b>
