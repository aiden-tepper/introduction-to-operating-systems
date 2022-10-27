
_customtest:     file format elf32-i386


Disassembly of section .text:

00001000 <main>:
#include "user.h"
#include "pstat.h"

int
main(int argc, char *argv[])
{
    1000:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    1004:	83 e4 f0             	and    $0xfffffff0,%esp
    1007:	ff 71 fc             	push   -0x4(%ecx)
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	53                   	push   %ebx
    100e:	51                   	push   %ecx
    100f:	81 ec 00 04 00 00    	sub    $0x400,%esp
   struct pstat st;
   int pid = getpid();
    1015:	e8 a4 02 00 00       	call   12be <getpid>
    101a:	89 c3                	mov    %eax,%ebx
   int defaulttickets = 0;
   
   if(getpinfo(&st) == 0)
    101c:	83 ec 0c             	sub    $0xc,%esp
    101f:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
    1025:	50                   	push   %eax
    1026:	e8 bb 02 00 00       	call   12e6 <getpinfo>
    102b:	83 c4 10             	add    $0x10,%esp
    102e:	85 c0                	test   %eax,%eax
    1030:	75 28                	jne    105a <main+0x5a>
   {
    for(int i = 0; i < NPROC; i++) {
    1032:	89 c2                	mov    %eax,%edx
    1034:	eb 03                	jmp    1039 <main+0x39>
    1036:	83 c2 01             	add    $0x1,%edx
    1039:	83 fa 3f             	cmp    $0x3f,%edx
    103c:	7f 30                	jg     106e <main+0x6e>
      if (st.inuse[i]) {
    103e:	83 bc 95 f8 fb ff ff 	cmpl   $0x0,-0x408(%ebp,%edx,4)
    1045:	00 
    1046:	74 ee                	je     1036 <main+0x36>
        if(st.pid[i] == pid) {
    1048:	39 9c 95 f8 fd ff ff 	cmp    %ebx,-0x208(%ebp,%edx,4)
    104f:	75 e5                	jne    1036 <main+0x36>
          defaulttickets = st.tickets[i];
    1051:	8b 84 95 f8 fc ff ff 	mov    -0x308(%ebp,%edx,4),%eax
    1058:	eb dc                	jmp    1036 <main+0x36>
      }
   }
   }
  else
  {
   printf(1, "getpinfo\t FAILED\n");
    105a:	83 ec 08             	sub    $0x8,%esp
    105d:	68 50 16 00 00       	push   $0x1650
    1062:	6a 01                	push   $0x1
    1064:	e8 3a 03 00 00       	call   13a3 <printf>
   exit();
    1069:	e8 d0 01 00 00       	call   123e <exit>
  }
  
  if(defaulttickets == 1)
    106e:	83 f8 01             	cmp    $0x1,%eax
    1071:	74 18                	je     108b <main+0x8b>
  {
   printf(1, "XV6_SCHEDULER\t SUCCESS\n");
  }
  else
  {
   printf(1, "%d defaulttickets\t FAILED\n", defaulttickets);
    1073:	83 ec 04             	sub    $0x4,%esp
    1076:	50                   	push   %eax
    1077:	68 7a 16 00 00       	push   $0x167a
    107c:	6a 01                	push   $0x1
    107e:	e8 20 03 00 00       	call   13a3 <printf>
    1083:	83 c4 10             	add    $0x10,%esp
  }
   exit();
    1086:	e8 b3 01 00 00       	call   123e <exit>
   printf(1, "XV6_SCHEDULER\t SUCCESS\n");
    108b:	83 ec 08             	sub    $0x8,%esp
    108e:	68 62 16 00 00       	push   $0x1662
    1093:	6a 01                	push   $0x1
    1095:	e8 09 03 00 00       	call   13a3 <printf>
    109a:	83 c4 10             	add    $0x10,%esp
    109d:	eb e7                	jmp    1086 <main+0x86>

0000109f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    109f:	55                   	push   %ebp
    10a0:	89 e5                	mov    %esp,%ebp
    10a2:	56                   	push   %esi
    10a3:	53                   	push   %ebx
    10a4:	8b 75 08             	mov    0x8(%ebp),%esi
    10a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    10aa:	89 f0                	mov    %esi,%eax
    10ac:	89 d1                	mov    %edx,%ecx
    10ae:	83 c2 01             	add    $0x1,%edx
    10b1:	89 c3                	mov    %eax,%ebx
    10b3:	83 c0 01             	add    $0x1,%eax
    10b6:	0f b6 09             	movzbl (%ecx),%ecx
    10b9:	88 0b                	mov    %cl,(%ebx)
    10bb:	84 c9                	test   %cl,%cl
    10bd:	75 ed                	jne    10ac <strcpy+0xd>
    ;
  return os;
}
    10bf:	89 f0                	mov    %esi,%eax
    10c1:	5b                   	pop    %ebx
    10c2:	5e                   	pop    %esi
    10c3:	5d                   	pop    %ebp
    10c4:	c3                   	ret    

000010c5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10c5:	55                   	push   %ebp
    10c6:	89 e5                	mov    %esp,%ebp
    10c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
    10cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    10ce:	eb 06                	jmp    10d6 <strcmp+0x11>
    p++, q++;
    10d0:	83 c1 01             	add    $0x1,%ecx
    10d3:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    10d6:	0f b6 01             	movzbl (%ecx),%eax
    10d9:	84 c0                	test   %al,%al
    10db:	74 04                	je     10e1 <strcmp+0x1c>
    10dd:	3a 02                	cmp    (%edx),%al
    10df:	74 ef                	je     10d0 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
    10e1:	0f b6 c0             	movzbl %al,%eax
    10e4:	0f b6 12             	movzbl (%edx),%edx
    10e7:	29 d0                	sub    %edx,%eax
}
    10e9:	5d                   	pop    %ebp
    10ea:	c3                   	ret    

000010eb <strlen>:

uint
strlen(const char *s)
{
    10eb:	55                   	push   %ebp
    10ec:	89 e5                	mov    %esp,%ebp
    10ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    10f1:	b8 00 00 00 00       	mov    $0x0,%eax
    10f6:	eb 03                	jmp    10fb <strlen+0x10>
    10f8:	83 c0 01             	add    $0x1,%eax
    10fb:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
    10ff:	75 f7                	jne    10f8 <strlen+0xd>
    ;
  return n;
}
    1101:	5d                   	pop    %ebp
    1102:	c3                   	ret    

00001103 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1103:	55                   	push   %ebp
    1104:	89 e5                	mov    %esp,%ebp
    1106:	57                   	push   %edi
    1107:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    110a:	89 d7                	mov    %edx,%edi
    110c:	8b 4d 10             	mov    0x10(%ebp),%ecx
    110f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1112:	fc                   	cld    
    1113:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1115:	89 d0                	mov    %edx,%eax
    1117:	8b 7d fc             	mov    -0x4(%ebp),%edi
    111a:	c9                   	leave  
    111b:	c3                   	ret    

0000111c <strchr>:

char*
strchr(const char *s, char c)
{
    111c:	55                   	push   %ebp
    111d:	89 e5                	mov    %esp,%ebp
    111f:	8b 45 08             	mov    0x8(%ebp),%eax
    1122:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    1126:	eb 03                	jmp    112b <strchr+0xf>
    1128:	83 c0 01             	add    $0x1,%eax
    112b:	0f b6 10             	movzbl (%eax),%edx
    112e:	84 d2                	test   %dl,%dl
    1130:	74 06                	je     1138 <strchr+0x1c>
    if(*s == c)
    1132:	38 ca                	cmp    %cl,%dl
    1134:	75 f2                	jne    1128 <strchr+0xc>
    1136:	eb 05                	jmp    113d <strchr+0x21>
      return (char*)s;
  return 0;
    1138:	b8 00 00 00 00       	mov    $0x0,%eax
}
    113d:	5d                   	pop    %ebp
    113e:	c3                   	ret    

0000113f <gets>:

char*
gets(char *buf, int max)
{
    113f:	55                   	push   %ebp
    1140:	89 e5                	mov    %esp,%ebp
    1142:	57                   	push   %edi
    1143:	56                   	push   %esi
    1144:	53                   	push   %ebx
    1145:	83 ec 1c             	sub    $0x1c,%esp
    1148:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    114b:	bb 00 00 00 00       	mov    $0x0,%ebx
    1150:	89 de                	mov    %ebx,%esi
    1152:	83 c3 01             	add    $0x1,%ebx
    1155:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1158:	7d 2e                	jge    1188 <gets+0x49>
    cc = read(0, &c, 1);
    115a:	83 ec 04             	sub    $0x4,%esp
    115d:	6a 01                	push   $0x1
    115f:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1162:	50                   	push   %eax
    1163:	6a 00                	push   $0x0
    1165:	e8 ec 00 00 00       	call   1256 <read>
    if(cc < 1)
    116a:	83 c4 10             	add    $0x10,%esp
    116d:	85 c0                	test   %eax,%eax
    116f:	7e 17                	jle    1188 <gets+0x49>
      break;
    buf[i++] = c;
    1171:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1175:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
    1178:	3c 0a                	cmp    $0xa,%al
    117a:	0f 94 c2             	sete   %dl
    117d:	3c 0d                	cmp    $0xd,%al
    117f:	0f 94 c0             	sete   %al
    1182:	08 c2                	or     %al,%dl
    1184:	74 ca                	je     1150 <gets+0x11>
    buf[i++] = c;
    1186:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    1188:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    118c:	89 f8                	mov    %edi,%eax
    118e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1191:	5b                   	pop    %ebx
    1192:	5e                   	pop    %esi
    1193:	5f                   	pop    %edi
    1194:	5d                   	pop    %ebp
    1195:	c3                   	ret    

00001196 <stat>:

int
stat(const char *n, struct stat *st)
{
    1196:	55                   	push   %ebp
    1197:	89 e5                	mov    %esp,%ebp
    1199:	56                   	push   %esi
    119a:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    119b:	83 ec 08             	sub    $0x8,%esp
    119e:	6a 00                	push   $0x0
    11a0:	ff 75 08             	push   0x8(%ebp)
    11a3:	e8 d6 00 00 00       	call   127e <open>
  if(fd < 0)
    11a8:	83 c4 10             	add    $0x10,%esp
    11ab:	85 c0                	test   %eax,%eax
    11ad:	78 24                	js     11d3 <stat+0x3d>
    11af:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    11b1:	83 ec 08             	sub    $0x8,%esp
    11b4:	ff 75 0c             	push   0xc(%ebp)
    11b7:	50                   	push   %eax
    11b8:	e8 d9 00 00 00       	call   1296 <fstat>
    11bd:	89 c6                	mov    %eax,%esi
  close(fd);
    11bf:	89 1c 24             	mov    %ebx,(%esp)
    11c2:	e8 9f 00 00 00       	call   1266 <close>
  return r;
    11c7:	83 c4 10             	add    $0x10,%esp
}
    11ca:	89 f0                	mov    %esi,%eax
    11cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11cf:	5b                   	pop    %ebx
    11d0:	5e                   	pop    %esi
    11d1:	5d                   	pop    %ebp
    11d2:	c3                   	ret    
    return -1;
    11d3:	be ff ff ff ff       	mov    $0xffffffff,%esi
    11d8:	eb f0                	jmp    11ca <stat+0x34>

000011da <atoi>:

int
atoi(const char *s)
{
    11da:	55                   	push   %ebp
    11db:	89 e5                	mov    %esp,%ebp
    11dd:	53                   	push   %ebx
    11de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
    11e1:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
    11e6:	eb 10                	jmp    11f8 <atoi+0x1e>
    n = n*10 + *s++ - '0';
    11e8:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
    11eb:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
    11ee:	83 c1 01             	add    $0x1,%ecx
    11f1:	0f be c0             	movsbl %al,%eax
    11f4:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
  while('0' <= *s && *s <= '9')
    11f8:	0f b6 01             	movzbl (%ecx),%eax
    11fb:	8d 58 d0             	lea    -0x30(%eax),%ebx
    11fe:	80 fb 09             	cmp    $0x9,%bl
    1201:	76 e5                	jbe    11e8 <atoi+0xe>
  return n;
}
    1203:	89 d0                	mov    %edx,%eax
    1205:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1208:	c9                   	leave  
    1209:	c3                   	ret    

0000120a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    120a:	55                   	push   %ebp
    120b:	89 e5                	mov    %esp,%ebp
    120d:	56                   	push   %esi
    120e:	53                   	push   %ebx
    120f:	8b 75 08             	mov    0x8(%ebp),%esi
    1212:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1215:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
    1218:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
    121a:	eb 0d                	jmp    1229 <memmove+0x1f>
    *dst++ = *src++;
    121c:	0f b6 01             	movzbl (%ecx),%eax
    121f:	88 02                	mov    %al,(%edx)
    1221:	8d 49 01             	lea    0x1(%ecx),%ecx
    1224:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
    1227:	89 d8                	mov    %ebx,%eax
    1229:	8d 58 ff             	lea    -0x1(%eax),%ebx
    122c:	85 c0                	test   %eax,%eax
    122e:	7f ec                	jg     121c <memmove+0x12>
  return vdst;
}
    1230:	89 f0                	mov    %esi,%eax
    1232:	5b                   	pop    %ebx
    1233:	5e                   	pop    %esi
    1234:	5d                   	pop    %ebp
    1235:	c3                   	ret    

00001236 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1236:	b8 01 00 00 00       	mov    $0x1,%eax
    123b:	cd 40                	int    $0x40
    123d:	c3                   	ret    

0000123e <exit>:
SYSCALL(exit)
    123e:	b8 02 00 00 00       	mov    $0x2,%eax
    1243:	cd 40                	int    $0x40
    1245:	c3                   	ret    

00001246 <wait>:
SYSCALL(wait)
    1246:	b8 03 00 00 00       	mov    $0x3,%eax
    124b:	cd 40                	int    $0x40
    124d:	c3                   	ret    

0000124e <pipe>:
SYSCALL(pipe)
    124e:	b8 04 00 00 00       	mov    $0x4,%eax
    1253:	cd 40                	int    $0x40
    1255:	c3                   	ret    

00001256 <read>:
SYSCALL(read)
    1256:	b8 05 00 00 00       	mov    $0x5,%eax
    125b:	cd 40                	int    $0x40
    125d:	c3                   	ret    

0000125e <write>:
SYSCALL(write)
    125e:	b8 10 00 00 00       	mov    $0x10,%eax
    1263:	cd 40                	int    $0x40
    1265:	c3                   	ret    

00001266 <close>:
SYSCALL(close)
    1266:	b8 15 00 00 00       	mov    $0x15,%eax
    126b:	cd 40                	int    $0x40
    126d:	c3                   	ret    

0000126e <kill>:
SYSCALL(kill)
    126e:	b8 06 00 00 00       	mov    $0x6,%eax
    1273:	cd 40                	int    $0x40
    1275:	c3                   	ret    

00001276 <exec>:
SYSCALL(exec)
    1276:	b8 07 00 00 00       	mov    $0x7,%eax
    127b:	cd 40                	int    $0x40
    127d:	c3                   	ret    

0000127e <open>:
SYSCALL(open)
    127e:	b8 0f 00 00 00       	mov    $0xf,%eax
    1283:	cd 40                	int    $0x40
    1285:	c3                   	ret    

00001286 <mknod>:
SYSCALL(mknod)
    1286:	b8 11 00 00 00       	mov    $0x11,%eax
    128b:	cd 40                	int    $0x40
    128d:	c3                   	ret    

0000128e <unlink>:
SYSCALL(unlink)
    128e:	b8 12 00 00 00       	mov    $0x12,%eax
    1293:	cd 40                	int    $0x40
    1295:	c3                   	ret    

00001296 <fstat>:
SYSCALL(fstat)
    1296:	b8 08 00 00 00       	mov    $0x8,%eax
    129b:	cd 40                	int    $0x40
    129d:	c3                   	ret    

0000129e <link>:
SYSCALL(link)
    129e:	b8 13 00 00 00       	mov    $0x13,%eax
    12a3:	cd 40                	int    $0x40
    12a5:	c3                   	ret    

000012a6 <mkdir>:
SYSCALL(mkdir)
    12a6:	b8 14 00 00 00       	mov    $0x14,%eax
    12ab:	cd 40                	int    $0x40
    12ad:	c3                   	ret    

000012ae <chdir>:
SYSCALL(chdir)
    12ae:	b8 09 00 00 00       	mov    $0x9,%eax
    12b3:	cd 40                	int    $0x40
    12b5:	c3                   	ret    

000012b6 <dup>:
SYSCALL(dup)
    12b6:	b8 0a 00 00 00       	mov    $0xa,%eax
    12bb:	cd 40                	int    $0x40
    12bd:	c3                   	ret    

000012be <getpid>:
SYSCALL(getpid)
    12be:	b8 0b 00 00 00       	mov    $0xb,%eax
    12c3:	cd 40                	int    $0x40
    12c5:	c3                   	ret    

000012c6 <sbrk>:
SYSCALL(sbrk)
    12c6:	b8 0c 00 00 00       	mov    $0xc,%eax
    12cb:	cd 40                	int    $0x40
    12cd:	c3                   	ret    

000012ce <sleep>:
SYSCALL(sleep)
    12ce:	b8 0d 00 00 00       	mov    $0xd,%eax
    12d3:	cd 40                	int    $0x40
    12d5:	c3                   	ret    

000012d6 <uptime>:
SYSCALL(uptime)
    12d6:	b8 0e 00 00 00       	mov    $0xe,%eax
    12db:	cd 40                	int    $0x40
    12dd:	c3                   	ret    

000012de <settickets>:
SYSCALL(settickets)
    12de:	b8 16 00 00 00       	mov    $0x16,%eax
    12e3:	cd 40                	int    $0x40
    12e5:	c3                   	ret    

000012e6 <getpinfo>:
SYSCALL(getpinfo)
    12e6:	b8 17 00 00 00       	mov    $0x17,%eax
    12eb:	cd 40                	int    $0x40
    12ed:	c3                   	ret    

000012ee <mprotect>:
SYSCALL(mprotect)
    12ee:	b8 18 00 00 00       	mov    $0x18,%eax
    12f3:	cd 40                	int    $0x40
    12f5:	c3                   	ret    

000012f6 <munprotect>:
SYSCALL(munprotect)
    12f6:	b8 19 00 00 00       	mov    $0x19,%eax
    12fb:	cd 40                	int    $0x40
    12fd:	c3                   	ret    

000012fe <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    12fe:	55                   	push   %ebp
    12ff:	89 e5                	mov    %esp,%ebp
    1301:	83 ec 1c             	sub    $0x1c,%esp
    1304:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
    1307:	6a 01                	push   $0x1
    1309:	8d 55 f4             	lea    -0xc(%ebp),%edx
    130c:	52                   	push   %edx
    130d:	50                   	push   %eax
    130e:	e8 4b ff ff ff       	call   125e <write>
}
    1313:	83 c4 10             	add    $0x10,%esp
    1316:	c9                   	leave  
    1317:	c3                   	ret    

00001318 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1318:	55                   	push   %ebp
    1319:	89 e5                	mov    %esp,%ebp
    131b:	57                   	push   %edi
    131c:	56                   	push   %esi
    131d:	53                   	push   %ebx
    131e:	83 ec 2c             	sub    $0x2c,%esp
    1321:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1324:	89 d0                	mov    %edx,%eax
    1326:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1328:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    132c:	0f 95 c1             	setne  %cl
    132f:	c1 ea 1f             	shr    $0x1f,%edx
    1332:	84 d1                	test   %dl,%cl
    1334:	74 44                	je     137a <printint+0x62>
    neg = 1;
    x = -xx;
    1336:	f7 d8                	neg    %eax
    1338:	89 c1                	mov    %eax,%ecx
    neg = 1;
    133a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    1341:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
    1346:	89 c8                	mov    %ecx,%eax
    1348:	ba 00 00 00 00       	mov    $0x0,%edx
    134d:	f7 f6                	div    %esi
    134f:	89 df                	mov    %ebx,%edi
    1351:	83 c3 01             	add    $0x1,%ebx
    1354:	0f b6 92 f4 16 00 00 	movzbl 0x16f4(%edx),%edx
    135b:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
    135f:	89 ca                	mov    %ecx,%edx
    1361:	89 c1                	mov    %eax,%ecx
    1363:	39 d6                	cmp    %edx,%esi
    1365:	76 df                	jbe    1346 <printint+0x2e>
  if(neg)
    1367:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
    136b:	74 31                	je     139e <printint+0x86>
    buf[i++] = '-';
    136d:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    1372:	8d 5f 02             	lea    0x2(%edi),%ebx
    1375:	8b 75 d0             	mov    -0x30(%ebp),%esi
    1378:	eb 17                	jmp    1391 <printint+0x79>
    x = xx;
    137a:	89 c1                	mov    %eax,%ecx
  neg = 0;
    137c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    1383:	eb bc                	jmp    1341 <printint+0x29>

  while(--i >= 0)
    putc(fd, buf[i]);
    1385:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
    138a:	89 f0                	mov    %esi,%eax
    138c:	e8 6d ff ff ff       	call   12fe <putc>
  while(--i >= 0)
    1391:	83 eb 01             	sub    $0x1,%ebx
    1394:	79 ef                	jns    1385 <printint+0x6d>
}
    1396:	83 c4 2c             	add    $0x2c,%esp
    1399:	5b                   	pop    %ebx
    139a:	5e                   	pop    %esi
    139b:	5f                   	pop    %edi
    139c:	5d                   	pop    %ebp
    139d:	c3                   	ret    
    139e:	8b 75 d0             	mov    -0x30(%ebp),%esi
    13a1:	eb ee                	jmp    1391 <printint+0x79>

000013a3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    13a3:	55                   	push   %ebp
    13a4:	89 e5                	mov    %esp,%ebp
    13a6:	57                   	push   %edi
    13a7:	56                   	push   %esi
    13a8:	53                   	push   %ebx
    13a9:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    13ac:	8d 45 10             	lea    0x10(%ebp),%eax
    13af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
    13b2:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
    13b7:	bb 00 00 00 00       	mov    $0x0,%ebx
    13bc:	eb 14                	jmp    13d2 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    13be:	89 fa                	mov    %edi,%edx
    13c0:	8b 45 08             	mov    0x8(%ebp),%eax
    13c3:	e8 36 ff ff ff       	call   12fe <putc>
    13c8:	eb 05                	jmp    13cf <printf+0x2c>
      }
    } else if(state == '%'){
    13ca:	83 fe 25             	cmp    $0x25,%esi
    13cd:	74 25                	je     13f4 <printf+0x51>
  for(i = 0; fmt[i]; i++){
    13cf:	83 c3 01             	add    $0x1,%ebx
    13d2:	8b 45 0c             	mov    0xc(%ebp),%eax
    13d5:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
    13d9:	84 c0                	test   %al,%al
    13db:	0f 84 20 01 00 00    	je     1501 <printf+0x15e>
    c = fmt[i] & 0xff;
    13e1:	0f be f8             	movsbl %al,%edi
    13e4:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
    13e7:	85 f6                	test   %esi,%esi
    13e9:	75 df                	jne    13ca <printf+0x27>
      if(c == '%'){
    13eb:	83 f8 25             	cmp    $0x25,%eax
    13ee:	75 ce                	jne    13be <printf+0x1b>
        state = '%';
    13f0:	89 c6                	mov    %eax,%esi
    13f2:	eb db                	jmp    13cf <printf+0x2c>
      if(c == 'd'){
    13f4:	83 f8 25             	cmp    $0x25,%eax
    13f7:	0f 84 cf 00 00 00    	je     14cc <printf+0x129>
    13fd:	0f 8c dd 00 00 00    	jl     14e0 <printf+0x13d>
    1403:	83 f8 78             	cmp    $0x78,%eax
    1406:	0f 8f d4 00 00 00    	jg     14e0 <printf+0x13d>
    140c:	83 f8 63             	cmp    $0x63,%eax
    140f:	0f 8c cb 00 00 00    	jl     14e0 <printf+0x13d>
    1415:	83 e8 63             	sub    $0x63,%eax
    1418:	83 f8 15             	cmp    $0x15,%eax
    141b:	0f 87 bf 00 00 00    	ja     14e0 <printf+0x13d>
    1421:	ff 24 85 9c 16 00 00 	jmp    *0x169c(,%eax,4)
        printint(fd, *ap, 10, 1);
    1428:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    142b:	8b 17                	mov    (%edi),%edx
    142d:	83 ec 0c             	sub    $0xc,%esp
    1430:	6a 01                	push   $0x1
    1432:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1437:	8b 45 08             	mov    0x8(%ebp),%eax
    143a:	e8 d9 fe ff ff       	call   1318 <printint>
        ap++;
    143f:	83 c7 04             	add    $0x4,%edi
    1442:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    1445:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1448:	be 00 00 00 00       	mov    $0x0,%esi
    144d:	eb 80                	jmp    13cf <printf+0x2c>
        printint(fd, *ap, 16, 0);
    144f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    1452:	8b 17                	mov    (%edi),%edx
    1454:	83 ec 0c             	sub    $0xc,%esp
    1457:	6a 00                	push   $0x0
    1459:	b9 10 00 00 00       	mov    $0x10,%ecx
    145e:	8b 45 08             	mov    0x8(%ebp),%eax
    1461:	e8 b2 fe ff ff       	call   1318 <printint>
        ap++;
    1466:	83 c7 04             	add    $0x4,%edi
    1469:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    146c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    146f:	be 00 00 00 00       	mov    $0x0,%esi
    1474:	e9 56 ff ff ff       	jmp    13cf <printf+0x2c>
        s = (char*)*ap;
    1479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    147c:	8b 30                	mov    (%eax),%esi
        ap++;
    147e:	83 c0 04             	add    $0x4,%eax
    1481:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
    1484:	85 f6                	test   %esi,%esi
    1486:	75 15                	jne    149d <printf+0xfa>
          s = "(null)";
    1488:	be 95 16 00 00       	mov    $0x1695,%esi
    148d:	eb 0e                	jmp    149d <printf+0xfa>
          putc(fd, *s);
    148f:	0f be d2             	movsbl %dl,%edx
    1492:	8b 45 08             	mov    0x8(%ebp),%eax
    1495:	e8 64 fe ff ff       	call   12fe <putc>
          s++;
    149a:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
    149d:	0f b6 16             	movzbl (%esi),%edx
    14a0:	84 d2                	test   %dl,%dl
    14a2:	75 eb                	jne    148f <printf+0xec>
      state = 0;
    14a4:	be 00 00 00 00       	mov    $0x0,%esi
    14a9:	e9 21 ff ff ff       	jmp    13cf <printf+0x2c>
        putc(fd, *ap);
    14ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    14b1:	0f be 17             	movsbl (%edi),%edx
    14b4:	8b 45 08             	mov    0x8(%ebp),%eax
    14b7:	e8 42 fe ff ff       	call   12fe <putc>
        ap++;
    14bc:	83 c7 04             	add    $0x4,%edi
    14bf:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
    14c2:	be 00 00 00 00       	mov    $0x0,%esi
    14c7:	e9 03 ff ff ff       	jmp    13cf <printf+0x2c>
        putc(fd, c);
    14cc:	89 fa                	mov    %edi,%edx
    14ce:	8b 45 08             	mov    0x8(%ebp),%eax
    14d1:	e8 28 fe ff ff       	call   12fe <putc>
      state = 0;
    14d6:	be 00 00 00 00       	mov    $0x0,%esi
    14db:	e9 ef fe ff ff       	jmp    13cf <printf+0x2c>
        putc(fd, '%');
    14e0:	ba 25 00 00 00       	mov    $0x25,%edx
    14e5:	8b 45 08             	mov    0x8(%ebp),%eax
    14e8:	e8 11 fe ff ff       	call   12fe <putc>
        putc(fd, c);
    14ed:	89 fa                	mov    %edi,%edx
    14ef:	8b 45 08             	mov    0x8(%ebp),%eax
    14f2:	e8 07 fe ff ff       	call   12fe <putc>
      state = 0;
    14f7:	be 00 00 00 00       	mov    $0x0,%esi
    14fc:	e9 ce fe ff ff       	jmp    13cf <printf+0x2c>
    }
  }
}
    1501:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1504:	5b                   	pop    %ebx
    1505:	5e                   	pop    %esi
    1506:	5f                   	pop    %edi
    1507:	5d                   	pop    %ebp
    1508:	c3                   	ret    

00001509 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1509:	55                   	push   %ebp
    150a:	89 e5                	mov    %esp,%ebp
    150c:	57                   	push   %edi
    150d:	56                   	push   %esi
    150e:	53                   	push   %ebx
    150f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1512:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1515:	a1 98 19 00 00       	mov    0x1998,%eax
    151a:	eb 02                	jmp    151e <free+0x15>
    151c:	89 d0                	mov    %edx,%eax
    151e:	39 c8                	cmp    %ecx,%eax
    1520:	73 04                	jae    1526 <free+0x1d>
    1522:	39 08                	cmp    %ecx,(%eax)
    1524:	77 12                	ja     1538 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1526:	8b 10                	mov    (%eax),%edx
    1528:	39 c2                	cmp    %eax,%edx
    152a:	77 f0                	ja     151c <free+0x13>
    152c:	39 c8                	cmp    %ecx,%eax
    152e:	72 08                	jb     1538 <free+0x2f>
    1530:	39 ca                	cmp    %ecx,%edx
    1532:	77 04                	ja     1538 <free+0x2f>
    1534:	89 d0                	mov    %edx,%eax
    1536:	eb e6                	jmp    151e <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1538:	8b 73 fc             	mov    -0x4(%ebx),%esi
    153b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    153e:	8b 10                	mov    (%eax),%edx
    1540:	39 d7                	cmp    %edx,%edi
    1542:	74 19                	je     155d <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1544:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1547:	8b 50 04             	mov    0x4(%eax),%edx
    154a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    154d:	39 ce                	cmp    %ecx,%esi
    154f:	74 1b                	je     156c <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1551:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1553:	a3 98 19 00 00       	mov    %eax,0x1998
}
    1558:	5b                   	pop    %ebx
    1559:	5e                   	pop    %esi
    155a:	5f                   	pop    %edi
    155b:	5d                   	pop    %ebp
    155c:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    155d:	03 72 04             	add    0x4(%edx),%esi
    1560:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1563:	8b 10                	mov    (%eax),%edx
    1565:	8b 12                	mov    (%edx),%edx
    1567:	89 53 f8             	mov    %edx,-0x8(%ebx)
    156a:	eb db                	jmp    1547 <free+0x3e>
    p->s.size += bp->s.size;
    156c:	03 53 fc             	add    -0x4(%ebx),%edx
    156f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1572:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1575:	89 10                	mov    %edx,(%eax)
    1577:	eb da                	jmp    1553 <free+0x4a>

00001579 <morecore>:

static Header*
morecore(uint nu)
{
    1579:	55                   	push   %ebp
    157a:	89 e5                	mov    %esp,%ebp
    157c:	53                   	push   %ebx
    157d:	83 ec 04             	sub    $0x4,%esp
    1580:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
    1582:	3d ff 0f 00 00       	cmp    $0xfff,%eax
    1587:	77 05                	ja     158e <morecore+0x15>
    nu = 4096;
    1589:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
    158e:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    1595:	83 ec 0c             	sub    $0xc,%esp
    1598:	50                   	push   %eax
    1599:	e8 28 fd ff ff       	call   12c6 <sbrk>
  if(p == (char*)-1)
    159e:	83 c4 10             	add    $0x10,%esp
    15a1:	83 f8 ff             	cmp    $0xffffffff,%eax
    15a4:	74 1c                	je     15c2 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    15a6:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    15a9:	83 c0 08             	add    $0x8,%eax
    15ac:	83 ec 0c             	sub    $0xc,%esp
    15af:	50                   	push   %eax
    15b0:	e8 54 ff ff ff       	call   1509 <free>
  return freep;
    15b5:	a1 98 19 00 00       	mov    0x1998,%eax
    15ba:	83 c4 10             	add    $0x10,%esp
}
    15bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    15c0:	c9                   	leave  
    15c1:	c3                   	ret    
    return 0;
    15c2:	b8 00 00 00 00       	mov    $0x0,%eax
    15c7:	eb f4                	jmp    15bd <morecore+0x44>

000015c9 <malloc>:

void*
malloc(uint nbytes)
{
    15c9:	55                   	push   %ebp
    15ca:	89 e5                	mov    %esp,%ebp
    15cc:	53                   	push   %ebx
    15cd:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    15d0:	8b 45 08             	mov    0x8(%ebp),%eax
    15d3:	8d 58 07             	lea    0x7(%eax),%ebx
    15d6:	c1 eb 03             	shr    $0x3,%ebx
    15d9:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    15dc:	8b 0d 98 19 00 00    	mov    0x1998,%ecx
    15e2:	85 c9                	test   %ecx,%ecx
    15e4:	74 04                	je     15ea <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15e6:	8b 01                	mov    (%ecx),%eax
    15e8:	eb 4a                	jmp    1634 <malloc+0x6b>
    base.s.ptr = freep = prevp = &base;
    15ea:	c7 05 98 19 00 00 9c 	movl   $0x199c,0x1998
    15f1:	19 00 00 
    15f4:	c7 05 9c 19 00 00 9c 	movl   $0x199c,0x199c
    15fb:	19 00 00 
    base.s.size = 0;
    15fe:	c7 05 a0 19 00 00 00 	movl   $0x0,0x19a0
    1605:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    1608:	b9 9c 19 00 00       	mov    $0x199c,%ecx
    160d:	eb d7                	jmp    15e6 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
    160f:	74 19                	je     162a <malloc+0x61>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    1611:	29 da                	sub    %ebx,%edx
    1613:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1616:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    1619:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    161c:	89 0d 98 19 00 00    	mov    %ecx,0x1998
      return (void*)(p + 1);
    1622:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1625:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1628:	c9                   	leave  
    1629:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    162a:	8b 10                	mov    (%eax),%edx
    162c:	89 11                	mov    %edx,(%ecx)
    162e:	eb ec                	jmp    161c <malloc+0x53>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1630:	89 c1                	mov    %eax,%ecx
    1632:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
    1634:	8b 50 04             	mov    0x4(%eax),%edx
    1637:	39 da                	cmp    %ebx,%edx
    1639:	73 d4                	jae    160f <malloc+0x46>
    if(p == freep)
    163b:	39 05 98 19 00 00    	cmp    %eax,0x1998
    1641:	75 ed                	jne    1630 <malloc+0x67>
      if((p = morecore(nunits)) == 0)
    1643:	89 d8                	mov    %ebx,%eax
    1645:	e8 2f ff ff ff       	call   1579 <morecore>
    164a:	85 c0                	test   %eax,%eax
    164c:	75 e2                	jne    1630 <malloc+0x67>
    164e:	eb d5                	jmp    1625 <malloc+0x5c>
