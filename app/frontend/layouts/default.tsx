import { AppSidebar } from "@/components/app-sidebar";
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb";
import { Separator } from "@/components/ui/separator";
import {
  SidebarInset,
  SidebarProvider,
  SidebarTrigger,
} from "@/components/ui/sidebar";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert.tsx";
import { AlertCircleIcon, CheckCircle2Icon, InfoIcon, PopcornIcon } from "lucide-react";
import { usePage } from "@inertiajs/react";
import { SharedProps } from "@/props/authorizedSharedProps";

export default function DefaultLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const sharedProps = usePage<SharedProps>().props;

  console.log('sharedProps', sharedProps);

  const flashType =
    sharedProps.has_flash ?
      Object.keys(sharedProps.flash).filter((key) =>
        ["error", "success", "info", "alert", "notice"].includes(key),
      )[0] || "info"
    : "info";

  const iconLookup: Record<string, React.ReactNode> = {
    success: <CheckCircle2Icon />,
    error: <AlertCircleIcon />,
    info: <PopcornIcon />,
    alert: <AlertCircleIcon />,
    notice: <InfoIcon />,
  };

  return (
    <SidebarProvider>
      <AppSidebar />
      <SidebarInset>
        <header className="flex h-16 shrink-0 items-center gap-2 transition-[width,height] ease-linear group-has-data-[collapsible=icon]/sidebar-wrapper:h-12">
          <div className="flex items-center gap-2 px-4">
            <SidebarTrigger className="-ml-1" />
            <Separator
              orientation="vertical"
              className="mr-2 data-[orientation=vertical]:h-4"
            />
            <Breadcrumb>
              <BreadcrumbList>
                <BreadcrumbItem className="hidden md:block">
                  <BreadcrumbLink href="#">
                    Building Your Application
                  </BreadcrumbLink>
                </BreadcrumbItem>
                <BreadcrumbSeparator className="hidden md:block" />
                <BreadcrumbItem>
                  <BreadcrumbPage>Data Fetching</BreadcrumbPage>
                </BreadcrumbItem>
              </BreadcrumbList>
            </Breadcrumb>
          </div>
        </header>
        <div className="flex justify-center items-center">
          <div className="grid w-full max-w-xl items-start gap-4 py-2">
            {sharedProps.has_flash ?
              <Alert>
                {iconLookup[flashType] ?? <PopcornIcon />}
                <AlertTitle className="capitalize">{flashType}</AlertTitle>
                <AlertDescription>
                  {sharedProps.flash[flashType]}
                </AlertDescription>
              </Alert>
            : null}
          </div>
        </div>
        {children}
      </SidebarInset>
    </SidebarProvider>
  );
}
