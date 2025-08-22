import PublicNavbar from "@/components/public-navbar.tsx";
import FlashMessages from "@/components/ui/flash-messages.tsx";

export default function PublicLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <>
      <PublicNavbar />
      <FlashMessages />
      {children}
    </>
  );
}
